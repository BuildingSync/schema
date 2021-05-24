# *********************************************************************************************************
# BuildingSync®, Copyright (c) 2015-2021, Alliance for Sustainable Energy, LLC, and other contributors.
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

require 'nokogiri'
require 'pp'
require 'open-uri'
require 'set'


RSpec.describe 'Validate Examples' do
  before :all do
    # Nokogiri doesn't seem to support XSDs which import other schemas with URLs
    # for the schemaLocation. To allow testing, we download the imported schema
    # and point schemaLocation to it instead
    schema_doc = Nokogiri::XML(File.read('BuildingSync.xsd'))

    GBXML_XSD_PATH = 'gbxml.xsd'
    GBXML_IMPORT_PATH = 'xs:schema/xs:import[@namespace = "http://www.gbxml.org/schema"]'
    if !File.file?(GBXML_XSD_PATH) then
      imported_schema_locations = schema_doc.xpath(GBXML_IMPORT_PATH).collect { |nokogiri_xml_node|
        nokogiri_xml_node.attribute("schemaLocation").value
      }
      expect(imported_schema_locations.length).to eq 1

      open(GBXML_XSD_PATH, 'wb') do |file|
        file << open(imported_schema_locations[0]).read
      end
    end

    schema_doc.xpath(GBXML_IMPORT_PATH).collect { |nokogiri_xml_node|
      nokogiri_xml_node.attribute("schemaLocation").value = GBXML_XSD_PATH
    }

    @xsd = Nokogiri::XML::Schema.from_document(schema_doc)
  end

  it 'should validate xmls' do
    total_errors = 0
    Dir['examples/*.xml'].each do |xml|
      puts "Validating file: #{xml}"
      # skip the invalid schema file
      next if xml =~ /Invalid Schema/

      doc = Nokogiri::XML(File.read(xml))

      errors = []
      @xsd.validate(doc).each do |error|
        errors << {file: xml, error: error}
      end
      unless errors.size.zero?
        puts "  There were #{errors.size} errors!"
        pp errors
      end
      total_errors += errors.size
      puts "\n"
    end

    expect(total_errors).to eq 0
  end
end


RSpec.describe 'No Tabs in Examples' do
  it 'should not have any tabs in the XMLS' do
    total_errors = 0
    Dir['examples/*.xml', 'BuildingSync.xsd'].each do |xml|
      puts "Checking for tabs in file: #{xml}"

      errors = []
      if File.read(xml).include? "\t"
        errors << "File #{xml} includes tabs, please remove the Tabs (run 'rake remove_tabs')"
      end

      unless errors.size.zero?
        puts "  There were #{errors.size} errors!"
        pp errors
      end

      total_errors += errors.size

      puts "\n"
    end

    expect(total_errors).to eq 0
  end
end

RSpec.describe 'No XMLSpy content' do
  it 'should not have any XMLSpy comments' do
    total_errors = 0
    Dir['examples/*.xml', 'BuildingSync.xsd'].each do |xml|
      puts "Checking for XMLSpy in file: #{xml}"

      errors = []
      if File.read(xml).include? "XMLSpy"
        errors << "File #{xml} includes XMLSpy, please remove the offending lines (run 'rake remove_tabs')"
      end

      unless errors.size.zero?
        puts "  There were #{errors.size} errors!"
        pp errors
      end

      total_errors += errors.size

      puts "\n"
    end

    expect(total_errors).to eq 0
  end
end

RSpec.describe 'No complexContent in XSD' do
  it 'should not have any complexContent' do
    expect(File.read('BuildingSync.xsd').include? "complexContent").to eq false
  end
end

RSpec.describe 'No naming collisions between schemas' do
  it 'should not have any collisions between names in schemas' do
    imported_schema_locations = File.open("BuildingSync.xsd", "r") do |file|
      xml_schema = Nokogiri::XML(file)
  
      xml_schema.xpath('xs:schema/xs:import').collect { |nokogiri_xml_node|
        nokogiri_xml_node.attribute("schemaLocation").value
      }
    end

    FILENAMES = ["BuildingSync.xsd"].concat(imported_schema_locations)
    NAMESPACES = {
      xs: "http://www.w3.org/2001/XMLSchema",
    }
    NAME_ATTRIBUTE = "name"

    XPATH_FOR_NAME_ATTRIBUTE = %w(attribute complexType element simpleType).collect { |s|
      "./xs:schema/xs:#{s}[@#{NAME_ATTRIBUTE}]"
    }.join(" | ")

    $stdout.puts("Checking files: #{FILENAMES.inspect}")

    sets = FILENAMES.collect { |filename|
      if filename.start_with?('http') then
        nokogiri_xml_document = Nokogiri::XML(URI.open(filename))
      else
        nokogiri_xml_document = File.open(filename, "r") do |file|
          Nokogiri::XML(file)
        end
      end

      nokogiri_xml_document.xpath(XPATH_FOR_NAME_ATTRIBUTE, **NAMESPACES).collect { |nokogiri_xml_node|
        nokogiri_xml_node.attribute(NAME_ATTRIBUTE).value
      }.to_set
    }

    # permitted because AT’s xsd2ruby script has already been tested with them and it was OK
    PERMITTED_CONFLICTS = %w(Capacity Latitude Location Longitude Manufacturer State ZipCode)

    conflicts = []
    sets.each_with_index do |set_a, a_index|
      sets.each_with_index do |set_b, b_index|
        if a_index < b_index then
          intersection_set = set_a.intersection(set_b).subtract(PERMITTED_CONFLICTS)
          if intersection_set.length() > 0 then
            found_conflict = true
            conflicts.append("Collision(s) between #{FILENAMES[a_index].inspect} and #{FILENAMES[b_index].inspect}: #{intersection_set.to_a.sort.inspect}")
          end
        end
      end
    end

    expect(conflicts).to be_empty
  end
end

RSpec.describe 'No naming collisions within the schema' do
  it 'should not have any elements with duplicate names' do
    schema_doc = Nokogiri::XML(File.read('BuildingSync.xsd'))
    named_elements = schema_doc.xpath("//xs:element[@name]")
    element_names = Hash.new
    named_elements.each do |node|
      element_name = node['name']
      if element_names.key?(element_name)
        element_names[element_name].append(node.line())
      else
        element_names[element_name] = [node.line()]
      end
    end

    # TODO: remove ignored dupes once we fix them all. (ie make no exceptions)
    # See https://github.com/BuildingSync/project-tracker/issues/21
    ignored_dupes = [
      'ActiveDehumidification',
      'AdvancedPowerStrip',
      'AnnualCoolingEfficiencyValue',
      'AnnualDemandSavingsCost',
      'AnnualHeatingEfficiencyValue',
      'AnnualPeakElectricityReduction',
      'AnnualSavingsByFuel',
      'AnnualSavingsByFuels',
      'AnnualSavingsCost',
      'AnnualSavingsNativeUnits',
      'AnnualSavingsSiteEnergy',
      'AnnualSavingsSourceEnergy',
      'AnnualWaterCostSavings',
      'AnnualWaterSavings',
      'AssemblyType',
      'BoilerLWT',
      'Building',
      'BurnerQuantity',
      'BurnerTurndownRatio',
      'CBECS',
      'CDDBaseTemperature',
      'Capacity',
      'ChilledWaterSupplyTemperature',
      'ClimateZone',
      'ClothesWasherCapacity',
      'ClothesWasherModifiedEnergyFactor',
      'ClothesWasherWaterFactor',
      'Combustion',
      'CombustionEfficiency',
      'CommunicationProtocol',
      'CondenserPlantID',
      'CondenserPlantIDs',
      'CondenserWaterTemperature',
      'CondensingTemperature',
      'Control',
      'ControlSensor',
      'ControlStrategy',
      'ControlSystemTypes',
      'Controls',
      'ConveyanceSystems',
      'CoolingSourceID',
      'CoolingStageCapacity',
      'DemandRatchetPercentage',
      'DemandRateAdjustment',
      'DemandWindow',
      'DryerElectricEnergyUsePerLoad',
      'DryerGasEnergyUsePerLoad',
      'ElectricDemandRate',
      'ElectricResistance',
      'EndTimestamp',
      'EndUse',
      'EnergyCostRate',
      'EnergyRateAdjustment',
      'EnergySellRate',
      'EnergyUse',
      'EquipmentDisposalAndSalvageCosts',
      'ExistingScheduleAffected',
      'ExteriorRoughness',
      'Facility',
      'FanBased',
      'FenestrationArea',
      'FloorsAboveGrade',
      'FloorsBelowGrade',
      'FoundationHeightAboveGrade',
      'FoundationWallConstruction',
      'FoundationWallInsulationCondition',
      'FoundationWallInsulationThickness',
      'FoundationWallRValue',
      'FoundationWallUFactor',
      'FundingFromIncentives',
      'FundingFromTaxCredits',
      'HDDBaseTemperature',
      'HeatPump',
      'HeatingStageCapacityFraction',
      'HotWaterBoilerMaximumFlowRate',
      'InputCapacity',
      'InteriorVisibleAbsorptance',
      'InternalRateOfReturn',
      'IntervalFrequency',
      'LampLabel',
      'LampPower',
      'LinkedBuildingID',
      'LinkedFacilityID',
      'LinkedScheduleID',
      'LinkedScheduleIDs',
      'LinkedSectionID',
      'LinkedSiteID',
      'LinkedSpaceID',
      'LinkedSystemID',
      'LinkedSystemIDs',
      'LinkedThermalZoneID',
      'MVCost',
      'MakeupAirSourceID',
      'Manual',
      'MeasureName',
      'MinimumPartLoadRatio',
      'ModifiedSchedule',
      'NPVofTaxImplications',
      'NetPresentValue',
      'NoCooling',
      'NoHeating',
      'NumberOfDiscreteCoolingStages',
      'NumberOfHeatingStages',
      'OMCostAnnualSavings',
      'Occupancy',
      'Other',
      'OtherCombination',
      'OtherControlStrategyName',
      'OtherControlTechnology',
      'OtherControlTechnologyName',
      'OutputCapacity',
      'PipeInsulationThickness',
      'PipeLocation',
      'PortfolioManager',
      'PrimaryFuel',
      'Priority',
      'RatePeriod',
      'RatePeriodName',
      'RatePeriods',
      'RatedCoolingSensibleHeatRatio',
      'RefrigerantChargeFactor',
      'RequiredVentilationRate',
      'Section',
      'SimplePayback',
      'Site',
      'SiteEnergyUse',
      'SlabArea',
      'SlabExposedPerimeter',
      'SlabInsulationCondition',
      'SlabInsulationThickness',
      'SlabPerimeter',
      'SourceEnergyUse',
      'SourceEnergyUseIntensity',
      'Space',
      'SpaceID',
      'SpaceIDs',
      'StartTimestamp',
      'SpatialUnit',
      'SpatialUnits',
      'SteamBoilerMaximumOperatingPressure',
      'SteamBoilerMinimumOperatingPressure',
      'Story',
      'StreetAdditionalInfo',
      'SummerPeakElectricityReduction',
      'ThermalEfficiency',
      'ThermalZone',
      'ThermalZoneID',
      'ThermalZoneIDs',
      'TimeSeries',
      'Timer',
      'TransformerNeeded',
      'Unknown',
      'UtilityAccountNumber',
      'UtilityBillpayer',
      'UtilityMeterNumber',
      'VentilationControlMethods',
      'VentilationRate',
      'WaterSideEconomizer',
      'WaterSideEconomizerDBTemperatureMaximum',
      'WaterSideEconomizerTemperatureMaximum',
      'WaterUse',
      'WeightedAverageLoad',
      'WinterPeakElectricityReduction',
      'YearOfConstruction'
    ]

    dupe_names = element_names.select{ |k, v| v.length() > 1 && !ignored_dupes.include?(k) }
    expect(dupe_names).to be_empty
  end
end

RSpec.describe 'Version translation from v2 to v3' do
  before :all do
    # TODO: DRY this up --- duplicate code from example validators spec above
  
    # Nokogiri doesn't seem to support XSDs which import other schemas with URLs
    # for the schemaLocation. To allow testing, we download the imported schema
    # and point schemaLocation to it instead
    schema_doc = Nokogiri::XML(File.read('BuildingSync.xsd'))

    GBXML_XSD_PATH = 'gbxml.xsd'
    GBXML_IMPORT_PATH = 'xs:schema/xs:import[@namespace = "http://www.gbxml.org/schema"]'
    if !File.file?(GBXML_XSD_PATH) then
      imported_schema_locations = schema_doc.xpath(GBXML_IMPORT_PATH).collect { |nokogiri_xml_node|
        nokogiri_xml_node.attribute("schemaLocation").value
      }
      expect(imported_schema_locations.length).to eq 1

      open(GBXML_XSD_PATH, 'wb') do |file|
        file << open(imported_schema_locations[0]).read
      end
    end

    schema_doc.xpath(GBXML_IMPORT_PATH).collect { |nokogiri_xml_node|
      nokogiri_xml_node.attribute("schemaLocation").value = GBXML_XSD_PATH
    }

    @xsd = Nokogiri::XML::Schema.from_document(schema_doc)

    # clean up output dir
    FileUtils.rm_rf('spec/output')
    FileUtils.mkdir_p('spec/output')
  end

  it 'should result in valid v3 file' do
    doc = Nokogiri::XML(File.read('spec/data/v2_for_translation.xml'))
    xslt_doc = Nokogiri::XML(File.read('translation/v2_to_v3.xsl'))
    # we must remove xsl:message from the stylesheet b/c nokogiri does not handle
    # them properly -- it considers it a failure.
    # See: https://github.com/sparklemotion/nokogiri/issues/1217
    xslt_doc.search('//xsl:message').remove
    xslt = Nokogiri::XSLT::Stylesheet.parse_stylesheet_doc(xslt_doc)

    transformed_doc = xslt.transform(doc)
    File.write('spec/output/v2_to_v3.xml', transformed_doc)

    expect(@xsd.validate(transformed_doc)).to be_empty
  end
end
