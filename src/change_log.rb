require 'github_api'
require 'date'
require 'yaml'
require 'optparse'
require 'optparse/date'
require 'pp'

# Instructions:
#   Install github_api gem, `gem install github_api`
#   Get a token from github's settings (https://github.com/settings/tokens)
#
# Example:
#   ruby change_log.rb -t abcdefghijklmnopqrstuvwxyz -s 2017-09-06
#

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: change_log.rb [options]'

  # defaults, go back 90 days
  options[:start_date] = Date.today - 90
  options[:end_date] = Date.today + 1

  opts.on('-s', '--start-date [DATE]', Date, 'Start of data (e.g. 2017-09-06)') do |v|
    options[:start_date] = v
  end
  opts.on('-e', '--end-date [DATE]', Date, 'End of data (e.g. 2017-09-13)') do |v|
    options[:end_date] = v
  end
  opts.on('-t', '--token [String]', String, 'Github API Token') do |v|
    options[:token] = v
  end
end.parse!

# Convert dates to time objects
options[:start_date] = Time.parse(options[:start_date].to_s)
options[:end_date] = Time.parse(options[:end_date].to_s)
puts options

### Repository options
repo_owner = 'BuildingSync'
repo = 'schema'

github = Github.new
if options[:token]
  puts 'Using github token'
  token = options[:token]
  github = Github.new oauth_token: token
end

total_open_issues = []
total_open_pull_requests = []
new_issues = []
closed_issues = []
accepted_pull_requests = []

def get_num(issue)
  issue.html_url.split('/')[-1].to_i
end

def get_issue_num(issue)
  "\##{get_num(issue)}"
end

def get_html_url(issue)
  issue.html_url
end

def get_title(issue)
  issue.title
end

def print_issue(issue)
  is_feature = false
  issue.labels.each {|label| is_feature = true if label.name == 'feature'}
  is_enhancement = false
  issue.labels.each {|label| is_enhancement = true if label.name == 'enhancement'}
  is_bug = false
  issue.labels.each {|label| is_bug = true if label.name == 'bug'}
  ignore = false
  issue.labels.each {|label| ignore = true if label.name == 'ignore'}

  quick_check = [is_feature, is_enhancement, is_bug]
  if !quick_check.none? and !quick_check.one?
    raise "Cannot only have one of [feature, enhancement, bug]. Seen on #{get_html_url(issue)}"
  end

  if is_feature
    text = "- New Feature [#{get_issue_num(issue)}]( #{get_html_url(issue)} ), #{get_title(issue)}"
  elsif is_enhancement
    text = "- Improved [#{get_issue_num(issue)}]( #{get_html_url(issue)} ), #{get_title(issue)}"
  elsif is_bug
    text = "- Fixed [#{get_issue_num(issue)}]( #{get_html_url(issue)} ), #{get_title(issue)}"
  else
    text = "- Merged [#{get_issue_num(issue)}]( #{get_html_url(issue)} ), #{get_title(issue)}"
  end

  [text, ignore]
end

# Process Open Issues
results = -1
page = 1
while results != 0
  resp = github.issues.list user: repo_owner, repo: repo, sort: 'created', direction: 'asc',
                            state: 'open', per_page: 100, page: page
  results = resp.length
  resp.env[:body].each do |issue, _index|
    created = Time.parse(issue.created_at)
    if !issue.key?(:pull_request)
      total_open_issues << issue
      if created >= options[:start_date] && created <= options[:end_date]
        new_issues << issue
      end
    else
      total_open_pull_requests << issue
    end
  end

  page += 1
end

# Process Closed Issues
results = -1
page = 1

# container for storing category of changes
categories = {
  "Controls" => 0,
  "Documentation" => 0,
  "General" => 0,
  "Measures" => 0,
  "Reports" => 0,
  "Systems" => 0,
  "Validation" => 0,
  "Other" => 0
}

change_type = {
    "Breaking Change" => 0,
    "Non-breaking Change" => 0
}

while results != 0
  # TODO: this needs to be a pull_request. For now have to manually check if the PR was closed, or merged.
  resp = github.issues.list user: repo_owner, repo: repo, sort: 'created', direction: 'asc',
                            state: 'closed', per_page: 100, page: page
  results = resp.length
  resp.env[:body].each do |issue, _index|
    # check if the issue is to be ignored

    next if issue.labels.to_s =~ /ignore/

    created = Time.parse(issue.created_at)
    closed = Time.parse(issue.closed_at)
    if !issue.key?(:pull_request)
      if created >= options[:start_date] && created <= options[:end_date]
        new_issues << issue
      end
      if closed >= options[:start_date] && closed <= options[:end_date]
        closed_issues << issue
      end
    elsif closed >= options[:start_date] && closed <= options[:end_date]
      accepted_pull_requests << issue

      # log the information about the PR
      issue.labels.each do |lbl|
        categories[lbl.name] += 1 if categories.key? lbl.name
        change_type[lbl.name] += 1 if change_type.key? lbl.name
      end
    end
  end

  page += 1
end

# postprocess the category
total_count = 0
categories.each_value do |v|
  total_count += v
end
categories["Other"] = accepted_pull_requests.size - total_count

closed_issues.sort! {|x, y| get_num(x) <=> get_num(y)}
new_issues.sort! {|x, y| get_num(x) <=> get_num(y)}
accepted_pull_requests.sort! {|x, y| get_num(x) <=> get_num(y)}
total_open_pull_requests.sort! {|x, y| get_num(x) <=> get_num(y)}

puts "Total Open Issues: #{total_open_issues.length}"
puts "Total Open Pull Requests: #{total_open_pull_requests.length}"
puts "\nDate Range: #{options[:start_date].strftime('%m/%d/%y')} - #{options[:end_date].strftime('%m/%d/%y')}"
puts "\n| Category       | Count |"
puts "|----------------|-------|"
categories.each do |k,v|
  puts "| #{k}         | #{v}  |"
end
puts "| **Total**      | #{accepted_pull_requests.size} |"
puts "\n| Change Type    | Count |"
puts "|----------------|-------|"
change_type.each do |k,v|
  puts "| #{k}         | #{v}  |"
end

puts "\nNew Issues: #{new_issues.length} (" + new_issues.map {|issue| get_issue_num(issue)}.join(', ') + ')'

puts "\nClosed Issues: #{closed_issues.length}"

closed_issues.each do |issue|
  issue_text, ignore = print_issue(issue)
  puts issue_text if not ignore
end

puts "\nAccepted Pull Requests: #{accepted_pull_requests.length}"
accepted_pull_requests.each do |issue|
  issue_text, ignore = print_issue(issue)
  puts issue_text if not ignore
end

puts "\nAll Open Issues: #{total_open_issues.length} (" + total_open_issues.map {|issue| get_issue_num(issue)}.join(', ') + ')'

