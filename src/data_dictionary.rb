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

require 'json'
require 'rubyXL/convenience_methods'

# Simple class that creates the data dictionary from the BuildingSync.xsd file
class DataDictionary
  def add_spaces(str)
    retval = str.dup
    regex = /(.*?[^ (])([A-Z][a-z])(.*?)/
    retval.gsub!(regex, '\1 \2\3') while retval.match(regex)
    regex = /(.*?)([a-z])([A-Z])(.*?)/
    retval.gsub!(regex, '\1\2 \3\4') while retval.match(regex)
    # Custom fixes
    retval.gsub!('e GRID', 'eGRID')
    retval.gsub!('EC Ms', 'ECMs')
    retval
  end

  def generate
    xsd = File.expand_path("#{File.dirname(__FILE__)}/../BuildingSync.xsd")
    @schema = Nokogiri::XML(IO.read(xsd), &:noblanks)
    # @schema.remove_namespaces!
    # puts @schema.css('element')
    # puts @schema.xpath('//')

    # elems = @schema.search 'element[name="Audits"]'
    # puts elems.length
    # elems.each_with_index { |elem, index|
    #  puts elem if index == 0
    # }

    workbook = RubyXL::Workbook.new # Create workbook

    # #######################
    # # Project Data Fields #
    # #######################
    # project = workbook[0]
    # row = col = 0
    # project.sheet_name = 'Project Data Fields' # Sheet 1
    # project.merge_cells(row, col, row, 4) # Merges A1:F1
    # project.add_cell(row, col, 'BuildingSync Data Dictionary, ' + Time.now.strftime('%m/%d/%Y')) # Title
    # project[row][col].change_horizontal_alignment('center')
    # project.change_row_bold(row, true)
    # project.change_row_font_name(row, 'Calibri')
    # project.change_row_font_size(row, 24)
    # project.change_row_height(row, 42)
    # project.change_row_vertical_alignment(row, 'top')
    #
    # # Headers
    # row += 1
    # headers = ['Category', 'Field', 'Description', 'Type', 'Units/Pattern']
    # widths = [15.14, 37.29, 67.86, 11, 17.86]
    # headers.map do |header|
    #   project.add_cell(row, col, header)
    #   project[row][col].change_horizontal_alignment('center')
    #   project.change_column_width(col, widths[col])
    #   col += 1
    # end
    # project.change_row_fill(row, '4f81bd')
    # project.change_row_font_color(row, 'ffffff')
    # project.change_row_bold(row, true)
    # project.change_row_font_name(row, 'Calibri')
    # project.change_row_font_size(row, 14)
    #
    # categories = ['Site', 'Customer', 'Facilities']
    #
    # #######################
    # # Systems Data Fields #
    # #######################
    # systems = workbook.add_worksheet('Systems Data Fields') # Sheet 2
    #
    # # Headers
    # row = col = 0
    # headers = ['Category', 'Field', 'Description', 'Type', 'Units/Pattern', 'Comment']
    # widths = [16.57, 38.71, 66.29, 14.57, 19.86, 11.29]
    # headers.map do |header|
    #   systems.add_cell(row, col, header)
    #   systems.sheet_data[row][col].change_horizontal_alignment('center')
    #   systems.change_column_width(col, widths[col])
    #   col += 1
    # end
    # systems.change_row_fill(row, '4f81bd')
    # systems.change_row_font_color(row, 'ffffff')
    # systems.change_row_bold(row, true)
    # systems.change_row_font_name(row, 'Calibri')
    # systems.change_row_font_size(row, 14)
    #
    # ########################
    # # Measures Data Fields #
    # ########################
    # measures = workbook.add_worksheet('Measures Data Fields') # Sheet 3
    # children = @schema.xpath('/xs:schema/xs:complexType[@name="MeasureType"]/xs:sequence').children
    #
    # # Headers
    # row = col = 0
    # headers = ['Category', 'Field', 'Description', 'Type', 'Units/Pattern']
    # widths = [16.14, 46.14, 63.29, 15.14, 19.43]
    # headers.map do |header|
    #   measures.add_cell(row, col, header)
    #   measures[row][col].change_horizontal_alignment('center')
    #   measures.change_column_width(col, widths[col])
    #   col += 1
    # end
    # measures.change_row_fill(row, '4f81bd')
    # measures.change_row_font_color(row, 'ffffff')
    # measures.change_row_bold(row, true)
    # measures.change_row_font_name(row, 'Calibri')
    # measures.change_row_font_size(row, 14)
    #
    # #########################
    # # Reporting Data Fields #
    # #########################
    # reporting = workbook.add_worksheet('Reporting Data Fields') # Sheet 4
    #
    # # Headers
    # row = col = 0
    # headers = ['Category', 'Field', 'Description', 'Type', 'Units/Pattern']
    # widths = [18.29, 29.57, 74.71, 13.43, 21.71]
    # headers.map do |header|
    #   reporting.add_cell(row, col, header)
    #   reporting.sheet_data[row][col].change_horizontal_alignment('center')
    #   reporting.change_column_width(col, widths[col])
    #   col += 1
    # end
    # reporting.change_row_fill(row, '4f81bd')
    # reporting.change_row_font_color(row, 'ffffff')
    # reporting.change_row_bold(row, true)
    # reporting.change_row_font_name(row, 'Calibri')
    # reporting.change_row_font_size(row, 14)

    ######################
    # Final Enumerations #
    ######################
    workbook.worksheets[0].sheet_name = 'Final Enumerations'
    enumerations = workbook.worksheets[0]

    enums = {}
    new_enums = []
    names = []
    @schema.xpath('//xs:simpleType/xs:restriction').map do |node|
      # Skip if current node has no enumerations (e.g., <auc:TelephoneNumber> is a pattern).
      next if node.xpath('.//xs:enumeration').none?

      data = {}

      name = node.parent.attribute('name')
      name = (name || node.parent.parent.attribute('name')) if name.nil?
      name = name.value

      data[:name] = name
      data[:sub_name] = nil
      data[:sub_display_name] = nil
      doc_string = node.parent.parent.xpath('.//xs:annotation/xs:documentation').first

      puts name

      if name == 'ClimateZone' ||
         name == 'LampLabel' ||
         name == 'MeasureName' ||
         name == 'AssemblyType' # Handle duplicate enum names

        # If measure name, then grab the documentation from the parents
        if name == 'MeasureName'
          doc_string = node.parent.parent.parent.parent.parent.xpath('.//xs:annotation/xs:documentation').first
        end

        if sub_name = node.parent.parent.parent.parent.parent.attribute('name')
          data[:sub_name] = sub_name.value
          name += " (#{sub_name.value})"
          data[:sub_display_name] = add_spaces(sub_name.value)
        end

      end

      data[:documentation] = doc_string ? doc_string.content : nil

      next unless node.children.length

      names.push(name)
      dupes = names.detect { |e| names.count(e) > 1 }
      raise 'Error: duplicate enum detected: ' + name unless dupes.nil?
      arr = []
      node.children.map do |child|
        value = child.attribute('value').value
        arr.push(value)
        dupes = arr.detect { |e| arr.count(e) > 1 }
        raise "Error: duplicate enum value detected: '#{value}' in '#{name}'" unless dupes.nil?
      end
      enums[add_spaces(name)] = arr

      data[:enumerations] = arr
      data[:enumerations_html] = "<ul><li>#{arr.join("</li><li>")}</li></ul>"

      new_enums << data
    end
    col = 0
    enums = enums.sort { |a, b| a[0].downcase <=> b[0].downcase }
    enumerations.change_row_fill(0, '4f81bd')
    enumerations.change_row_font_color(0, 'ffffff')
    enumerations.change_row_bold(0, true)
    enumerations.change_row_font_name(0, 'Calibri')
    enumerations.change_row_font_size(0, 11)
    max_row = 0
    enums.map do |enum, values|
      row = 0
      enumerations.add_cell(row, col, enum)
      values.each do |value|
        row += 1
        enumerations.add_cell(row, col, value)
        next unless max_row < row
        enumerations.change_row_fill(row, 'dce6f1')
        enumerations.change_row_font_name(row, 'Calibri')
        enumerations.change_row_font_size(row, 11)
        max_row = row
      end
      col += 1
    end

    # puts @schema.xpath('/xs:schema').children.length

    font = RubyXL::Font.new
    font.set_name('Calibri')
    font.set_size(11)
    FileUtils.mkdir_p 'docs'
    workbook.save('docs/DataDictionary.xlsx') # Save

    # also save as JSON
    # sore the new_data hash

    # NOTE If both `name` and `sub_name` attributes are given, then concatenate
    # the string literals.
    # NOTE Use `Enumerable#sort_by!` instance method for in-place sorting via a
    # Schwartzian transform (for improved performance).
    new_enums.sort_by! { |hash| [hash[:name], hash[:sub_name]].flatten.join('$') }
    pp new_enums

    File.open('docs/enumerations.json', 'w') { |f| f << JSON.pretty_generate(new_enums) }
  end
end
