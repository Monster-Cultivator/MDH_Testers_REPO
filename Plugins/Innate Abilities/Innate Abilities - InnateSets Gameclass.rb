module GameData
  class InnateSet
    attr_reader :id
    attr_reader :species
	  attr_reader :form
    attr_reader :innates
	  attr_reader :pbs_file_suffix

    DATA = {}
    DATA_FILENAME = "innate_sets.dat"
	  PBS_BASE_FILENAME = "innate_sets"
	
	  extend ClassMethodsSymbols
    include InstanceMethods
	
	SCHEMA = {
	"SectionName" => [:id,         "e", :Species],
	"innates" 	  => [:innates,    "*e", :Ability]
	}
	
  def self.load
    # Define file paths for both the PBS and .dat files
    pbs_file_path = "PBS/innate_sets.txt"
    data_file_path = File.join("Data", DATA_FILENAME)

    # Check if the PBS file exists and prioritize it
    if File.exist?(pbs_file_path)
      current_id = nil

      File.open(pbs_file_path, "r") do |file|
        file.each_line do |line|
          next if line.nil? # Accounts for empty lines in the PBS file
          line.strip!
          line = line.split('#').first&.strip # Avoids the nil:NilClass problem by empty lines
          next if line.empty? || line.start_with?("#")

          if line =~ /^\[(.+)\]$/
            current_id = $1.to_sym
            DATA[current_id] = { innates: [] }  # Initialize with an empty list of innates
          elsif line =~ /^Innates\d* = (.+)$/
            innates = $1.split(",").map(&:strip).map(&:to_sym)
            DATA[current_id][:innates] ||= []
            DATA[current_id][:innates] << innates  # Add to the list of innate sets
          end
        end
      end

      # Convert the hash to instances of InnateSet
      DATA.each do |id, attributes|
        DATA[id] = InnateSet.new(attributes)
      end

      # Save the data to the compiled .dat file in the Data folder
      File.open(data_file_path, "wb") { |f| Marshal.dump(DATA, f) }

    elsif File.exist?(data_file_path)
      # Load from the compiled .dat file if PBS file doesn't exist
      File.open(data_file_path, "rb") { |f| DATA.update(Marshal.load(f)) }
    else
      raise "No valid data source found: neither innate_sets.txt in PBS nor innate_sets.dat in Data."
    end
  end
    
  def self.get(id)
    return DATA[id] if DATA && DATA[id]
	  return InnateSet.new(id: id, species: id, innates: [], pbs_file_suffix: "")
    raise "Unknown ID #{id} in InnateSets"
  end
	
  def self.get_species_form(species, form)
    return nil if !species
    validate species => [Symbol, String]
    validate form => Integer
      
    species = species.to_sym if species.is_a?(String)
    species_form = form > 0 ? "#{species}_#{form}".to_sym : species
    DATA[species_form] || DATA[species]
  end

  def initialize(hash)
      @id                   = hash[:id]
      @species         		= hash[:species]     		   || @id
	    @form           	    = hash[:form]            	   || 0
      @innates  			= hash[:innates]               ||[] 
	    @pbs_file_suffix      = hash[:pbs_file_suffix]       || ""
  end

	alias __orig__get_property_for_PBS get_property_for_PBS unless method_defined?(:__orig__get_property_for_PBS)
    def get_property_for_PBS(key)
      ret = __orig__get_property_for_PBS(key)
      case key
      when "SectionName"
        ret = [@species, (@form > 0) ? @form : nil]
      end
      return ret
    end
  end
end