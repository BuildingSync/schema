# *********************************************************************************************************
# BuildingSync®, Copyright (c) 2015-2025, Alliance for Sustainable Energy, LLC, and other contributors.
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are permitted
# provided that the following conditions are met:
#
# (1) Redistributions of source code must retain the above copyright notice, this list of conditions
# and the following disclaimer.
#
# (2) Redistributions in binary form must reproduce the above copyright notice, this list of conditions
# and the following disclaimer in the documentation and/or other materials provided with the distribution.
#
# (3) Neither the name of the copyright holder nor the names of any contributors may be used to endorse
# or promote products derived from this software without specific prior written permission from the
# respective party.
#
# (4) Other than as required in clauses (1) and (2), distributions in any form of modifications or other
# derivative works may not use the "BuildingSync" trademark or any other confusingly similar designation
# without specific prior written permission from Alliance for Sustainable Energy, LLC.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER(S) AND ANY CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER(S), ANY
# CONTRIBUTORS, THE UNITED STATES GOVERNMENT, OR THE UNITED STATES DEPARTMENT OF ENERGY, NOR ANY OF
# THEIR EMPLOYEES, BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# *********************************************************************************************************

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
  options[:branch] = 'develop-v2'

  opts.on('-s', '--start-date [DATE]', Date, 'Start of data (e.g. 2017-09-06)') do |v|
    options[:start_date] = v
  end
  opts.on('-e', '--end-date [DATE]', Date, 'End of data (e.g. 2017-09-13)') do |v|
    options[:end_date] = v
  end
  opts.on('-t', '--token [String]', String, 'Github API Token') do |v|
    options[:token] = v
  end
  opts.on('-b', '--branch [String]', String, 'Github Branch to create changelog for') do |v|
    options[:branch] = v
  end
end.parse!

# Convert dates to time objects
options[:start_date] = Time.parse(options[:start_date].to_s)
options[:end_date] = Time.parse(options[:end_date].to_s)
puts options

### Repository options
repo_owner = 'BuildingSync'
repo = 'schema'

LABEL_BREAKING_CHANGE = "Breaking Change"
LABEL_NONBREAKING_CHANGE = "Non-breaking Change"
LABEL_NONSCHEMA_CHANGE = "Non-schema Change"
LABEL_SCHEMA_SCOPE_PREFIX = "Schema: "

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

def codify_labels(labels)
  scopes_as_tags = labels.map { |label| "`#{label.name.gsub(LABEL_SCHEMA_SCOPE_PREFIX, '')}`" }
  return "#{scopes_as_tags.join(", ")}"
end

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
  ignore = issue.labels.map { |label| label.name }.include? 'ignore'
  codified_labels = codify_labels(issue.labels)
  codified_labels = codified_labels.length > 0 ? " (#{codified_labels})" : ""
  text = "- [#{get_issue_num(issue)}]( #{get_html_url(issue)} ), #{get_title(issue)}#{codified_labels}"
  [text, ignore]
end

def print_pr(pr)
  scope_labels = pr.labels.map { |label| label if label.name.start_with? LABEL_SCHEMA_SCOPE_PREFIX }.compact
  codified_scopes = codify_labels(scope_labels)
  codified_scopes = codified_scopes.length > 0 ? " (#{codified_scopes})" : ""
  [" - [##{pr.number}](#{pr.html_url}), #{pr.title}#{codified_scopes}", false]
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

# Process merged PRs
pr_classifications = {
  LABEL_BREAKING_CHANGE => [],
  LABEL_NONBREAKING_CHANGE => [],
  LABEL_NONSCHEMA_CHANGE => []
}

scope_counter = {
  "Schema: Controls" => 0,
  "Schema: Documentation" => 0,
  "Schema: General" => 0,
  "Schema: Measures" => 0,
  "Schema: Reports" => 0,
  "Schema: Systems" => 0,
  "Schema: Validation" => 0,
  "Other" => 0
}

results = -1
page = 1
q = "repo:#{repo_owner}/#{repo} "\
    "is:pr is:merged "\
    "base:#{options[:branch]} "\
    "merged:#{options[:start_date].strftime('%Y-%m-%d')}..#{options[:end_date].strftime('%Y-%m-%d')}"

while results != 0
  resp = github.search.issues q: q, page: page
  results = resp.items.length
  resp.items.each do |pr, _index|
    label_names = pr.labels.map { |label| label.name }
    next if label_names.to_s =~ /ignore/

    accepted_pull_requests << pr
    if label_names.include? LABEL_BREAKING_CHANGE
      pr_classifications[LABEL_BREAKING_CHANGE] << pr
    elsif label_names.include? LABEL_NONBREAKING_CHANGE
      pr_classifications[LABEL_NONBREAKING_CHANGE] << pr
    elsif label_names.include? LABEL_NONSCHEMA_CHANGE
      pr_classifications[LABEL_NONSCHEMA_CHANGE] << pr
    else
      puts "WARNING: Labels do not specify implications of PR \"#{ pr.title }\", expected one of #{[LABEL_BREAKING_CHANGE, LABEL_NONBREAKING_CHANGE, LABEL_NONSCHEMA_CHANGE]}: #{ pr.labels }: #{pr.html_url}"
      pr_classifications[LABEL_NONSCHEMA_CHANGE] << pr
    end

    # log the information about the PR
    label_names.each do |label_name|
      scope_counter[label_name] += 1 if scope_counter.key? label_name
    end
  end

  page += 1
end

# Process Closed Issues
results = -1
page = 1

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
      end
  end

  page += 1
end

# postprocess the category
total_count = 0
scope_counter.each_value do |v|
  total_count += v
end
scope_counter["Other"] = accepted_pull_requests.size - total_count

closed_issues.sort! {|x, y| get_num(x) <=> get_num(y)}
new_issues.sort! {|x, y| get_num(x) <=> get_num(y)}
accepted_pull_requests.sort! {|x, y| get_num(x) <=> get_num(y)}
total_open_pull_requests.sort! {|x, y| get_num(x) <=> get_num(y)}

puts "Total Open Issues: #{total_open_issues.length}"
puts "Total Open Pull Requests: #{total_open_pull_requests.length}"
puts "\nDate Range: #{options[:start_date].strftime('%m/%d/%y')} - #{options[:end_date].strftime('%m/%d/%y')}"
puts "\n| Category       | Count |"
puts "|----------------|-------|"
scope_counter.each do |k,v|
  puts "| #{k}         | #{v}  |"
end
puts "| **Total**      | #{accepted_pull_requests.size} |"

pr_classifications.each do |change_type, prs|
  puts "\n### #{change_type}s"

  if prs.length == 0
    puts "\n*No #{change_type.downcase}s*"
  else
    prs.each do |pr, _index|
      pr_text, ignore = print_pr(pr)
      puts pr_text if not ignore
    end
  end
end

puts "\n### Issues"

puts "\nNew Issues: #{new_issues.length} (" + new_issues.map {|issue| get_issue_num(issue)}.join(', ') + ')'

puts "\nClosed Issues: #{closed_issues.length}"

closed_issues.each do |issue|
  issue_text, ignore = print_issue(issue)
  puts issue_text if not ignore
end


puts "\nAll Open Issues: #{total_open_issues.length} (" + total_open_issues.map {|issue| get_issue_num(issue)}.join(', ') + ')'
