class Pokemon
	attr_accessor :Innates
	attr_accessor :active_innates
	attr_accessor :fixed_innates
	attr_accessor :original_innates
	attr_accessor :form_innates
	attr_accessor :innateset
  attr_accessor :unlocked_innate_count
  #Adds the innates to a species datta
	def species=(species_id)
		new_species_data = GameData::Species.get(species_id)
		return if @species == new_species_data.species
		@species     = new_species_data.species
		default_form = new_species_data.default_form
    if default_form >= 0
			@form      = default_form
    elsif new_species_data.form > 0
			@form      = new_species_data.form
    end
		@forced_form = nil
		@gender      = nil if singleGendered?
		@level       = nil
		@ability     = nil
		@innate      = nil
		calc_stats
    assign_innate_abilities if respond_to?(:assign_innate_abilities)
	end
#=============================================================================
# Stuff related to innate abilities in a Pokemon.
#=============================================================================
  def unlocked_innate_count
    return @unlocked_innate_count || 0
  end

  def hasInnate?(ability)
    return true if self.active_innates.include?(ability)
    return false
  end

  def getInnateList
	  innate_set = GameData::InnateSet.get(species)
	  return [] unless innate_set

	  puts "[Innate Debug] Getting innate list for #{species}, form #{@form}"

	  if @form && @form > 0
		  innate_set = GameData::InnateSet.get_species_form(species, @form)
		  return [] unless innate_set
	  end

	  # Use evolution context if available
	  if defined?(@__previous_innates) && @__previous_innates
		  puts "[Innate Debug] Attempting to match evolved Pokémon's previous innate set..."
		  inherited_sorted = @__previous_innates.sort

		  innate_set.innates.each_with_index do |set, i|
		    puts "[Innate Debug] Comparing with Innates#{i + 1}: #{set.inspect}"
        if set.sort == inherited_sorted
			    puts "[Innate Debug] Match found with Innates#{i + 1}!"
			    return set
        end
      end

	    puts "[Innate Debug] No match found; selecting random set."
	  end

	  chosen = innate_set.innates.sample
	  puts "[Innate Debug] Randomly selected innate set: #{chosen.inspect}"
	  return chosen || []
  end
  #========================================================================================
  #Helper methods for the whole innate index requested by Uzi
  #========================================================================================
  def getInnateListFull
	  innate_set = GameData::InnateSet.get(species)
	  return [] unless innate_set

	  if form && form > 0
		  innate_set = GameData::InnateSet.get_species_form(species, form)
		  return [] unless innate_set
	  end

	  return innate_set.innates || []
  end
  
  def getInnateSetByIndex(index)
	  sets = getInnateListFull
	  return nil if index.nil? || index <= 0 || index > sets.length
	  return sets[index - 1]
  end
  
  def getInnateIndex
	  return 0 unless respond_to?(:species) && respond_to?(:active_innates)

	  species = self.species
	  form = self.form || 0
	  current_innates = self.active_innates&.map(&:to_sym)
	  return 0 if current_innates.nil? || current_innates.empty?

	  puts "[Innate Debug] Checking innate index for #{GameData::Species.get(species).name}, Form #{form}"
	  puts "[Innate Debug] Current innates: #{current_innates.inspect}"

	  sets = getInnateListFull
	  sets.each_with_index do |set, index|
		  puts "[Innate Debug] Comparing with set #{index + 1}: #{set.inspect}"
		  return index + 1 if set.sort == current_innates.sort
	  end

	  puts "[Innate Debug] No matching innate set found. Returning 0."
	  return 0
  end
  
  def innateset=(index)
    set = getInnateSetByIndex(index)

    if set.nil?
      puts "[Innate Debug] Tried to set invalid innate set index #{index}."
      return
    end

    list = set.compact.map(&:to_sym)

    @innateset = index
    @Innates = nil

    @active_innates = list.clone
    @fixed_innates  = list.clone

    @form_innates ||= {}
    @form_innates[[self.species, self.form || 0]] = list.clone

    @manual_active_innates = true

    puts "[Innate Debug] Changed innate set to #{@innateset}: #{list.inspect}"
  end
#========================================================================================
#========================================================================================
  def getInnateListName
    ret = []
    sp_data = species_data
    sp_data.innates.each_with_index { |a, i| ret.push(a) if a }
   # sp_data.hidden_abilities.each_with_index { |a, i| ret.push([a, i + 2]) if a }
    return ret
  end

  #Add one single innate
  def add_innate(innate)
    #return unless innate && GameData::Innate.exists?(innate)
    innate_symbol = innate.to_sym
    @Innates << innate_symbol unless @Innates.include?(innate_symbol)
  end

  # Optional: Clears all innates
  def clear_innates
    @Innates.clear
	puts "Innates cleared"
  end
  
  def empty_innates
    @Innates = nil
    puts "Innates set to nil"
  end

  # Optional: Add multiple innates at once
  def add_innates(*innates)
    innates.each { |innate| add_innate(innate) }
  end
  
  # For all of the innate randomizer stuff EXCEPT in battle
  def select_random_innates(max_innates, primary_ability)
    # Load all innate abilities into "Available Innates"
    available_innates = getInnateList#.map(&:first)
    # Remove the primary ability from the available innates
    available_innates.reject! { |ability| ability == primary_ability }
	  # If shuffling is disabled and the number of available innates is <= max_innates, return the innates as is
	  if !alwaysShuffleEnabled? && available_innates.size <= max_innates
		  return available_innates.take(max_innates)
	  end
    # Ensure max_innates does not exceed the number of available innates
    chosen_innates = []
    max_innates.times do
      chosen_innate = available_innates.sample
      break if chosen_innate.nil?
      chosen_innates.push(chosen_innate)
      available_innates.delete(chosen_innate)  # Remove the chosen innate to prevent duplicates
    end
	  puts "Possible Innates Randomized"
    return chosen_innates
  end
  
  # Method to randomly select innate abilities from all available abilities in the game
  def max_innate_randomizer(max_innates, primary_ability)
    # Initialize an empty array for available innates
    available_innates = []

    # Iterate through each ability and filter based on blacklist and primary ability
    GameData::Ability.each do |ability|
      next if Settings::BLACKLIST.include?(ability.id) || ability.id == primary_ability
      available_innates << ability.id
    end

    # Choose a random selection of innate abilities up to the specified max
    chosen_innates = available_innates.sample(max_innates)

    puts "Innate abilities randomized and assigned"
    return chosen_innates
  end
  
  
# Custom method to reset and re-roll innates for a form
  def reset_innates_for_form(form)
    @form_innates ||= {}

    species_form_key = [self.species, form]

    # Get correct ability for this form based on current ability_index
    species_data = GameData::Species.get_species_form(self.species, form)
    ability_list = species_data.abilities
    form_ability_id = ability_list[self.ability_index]

    # Clear previous innates
    @form_innates[species_form_key] = []

    if randomizerEnabled?
      if maxRandomizerEnabled?
        new_innates = max_innate_randomizer(maxInnates, form_ability_id)
        puts "#{self.name}'s innates for form #{form} re-rolled using max innate randomizer!"
      else
        new_innates = select_random_innates(maxInnates, form_ability_id)
        puts "#{self.name}'s innates for form #{form} re-rolled with randomized innates!"
      end
    else
      puts "#{self.name}'s innates for form #{form} are not randomized, kept as is."
      return
    end

    def active_innates
      @active_innates ||= []
      return @active_innates
    end

    def active_innates=(value)
      list = value || []
      list = list.compact.map(&:to_sym)

      @active_innates = list.clone

      # If this setter is called directly by outside code, preserve it.
      # assign_innate_abilities uses @active_innates directly, so it won't trip this.
      if !@__assigning_innates
        @manual_active_innates = true
        @form_innates ||= {}
        @form_innates[[self.species, self.form || 0]] = list.clone if !list.empty?
      end
    end
  # Prevent ability duplication in innates
  new_innates.reject! { |innate| innate == form_ability_id }

  @form_innates[species_form_key] = new_innates
  end
  #======================================================================================================
  #Master method
  # Edited by idite to handle Possession/Control stuff.
  #======================================================================================================
  def assign_innate_abilities
    @form_innates ||= {}

    species_form_key = [self.species, self.form || 0]

    #---------------------------------------------------------------------------
    # 1. Custom Innates must ALWAYS win.
    # This supports setBattleRule code that directly sets @Innates.
    #---------------------------------------------------------------------------
    custom = @Innates
    if custom && !custom.empty?
      list = custom.compact.map(&:to_sym)

      @active_innates = list.clone
      @fixed_innates  = list.clone
      @form_innates[species_form_key] = list.clone

      puts "Using customly given Innates..."
      puts "#{self.name}'s custom Innates set for species #{self.species} form #{self.form || 0}!"
      return
    end

    #---------------------------------------------------------------------------
    # 2. If something manually set active_innates, respect it.
    # This supports code that does pkmn.active_innates = [...]
    #---------------------------------------------------------------------------
    if @manual_active_innates && @active_innates && !@active_innates.empty?
      list = @active_innates.compact.map(&:to_sym)

      @active_innates = list.clone
      @fixed_innates  = list.clone
      @form_innates[species_form_key] = list.clone

      puts "Using manually assigned active Innates..."
      return
    end

    #---------------------------------------------------------------------------
    # 3. Forced innate set.
    #---------------------------------------------------------------------------
    if @innateset && (set = getInnateSetByIndex(@innateset))
      list = set.compact.map(&:to_sym)

      @active_innates = list.clone
      @fixed_innates  = list.clone
      @form_innates[species_form_key] = list.clone

      puts "Using Innate Set ##{@innateset}: #{list.inspect}"
      return
    end

    #---------------------------------------------------------------------------
    # 4. Existing form cache.
    # IMPORTANT: [] is truthy in Ruby, so only use the cache if it has contents.
    #---------------------------------------------------------------------------
    cached = @form_innates[species_form_key]
    if cached && !cached.empty?
      list = cached.compact.map(&:to_sym)

      @active_innates = list.clone
      @fixed_innates  = list.clone

      puts "Innates already assigned for species #{self.species} form #{self.form || 0}."
      return
    end

    #---------------------------------------------------------------------------
    # 5. Normal PBS/randomizer assignment.
    #---------------------------------------------------------------------------
    available_innates = getInnateList
    available_innates = [] if !available_innates
    available_innates = available_innates.compact.map(&:to_sym)
    available_innates.reject! { |innate| innate == self.ability_id }

    if randomizerEnabled?
      if maxRandomizerEnabled?
        @active_innates = max_innate_randomizer(maxInnates, self.ability_id)
        puts "Using fully random innates..."
      else
        @active_innates = select_random_innates(maxInnates, @ability_id)
        puts "Using possible randomized innates..."
      end
    else
      @active_innates = available_innates
      puts "Using innates straight from the pbs..."
    end

    @active_innates = [] if !@active_innates
    @active_innates = @active_innates.compact.map(&:to_sym)
    @fixed_innates  = @active_innates.clone

    @form_innates[species_form_key] = @active_innates.clone

    # This was normal automatic assignment, not a manual override.
    @manual_active_innates = false

    puts "#{self.name}'s Innates set for species #{self.species} form #{self.form || 0}!"

    if instance_variable_defined?(:@__previous_innates)
      remove_instance_variable(:@__previous_innates)
      puts "[Innate Debug] Removed stored innates from evolution."
    end
  end
#======================================================================================================
#======================================================================================================
  
  def Innates=(value)
    @form_innates ||= {}
    species_form_key = [self.species, self.form || 0]

    if value.nil? || value.empty?
      @Innates = nil
      @form_innates.delete(species_form_key)
      @manual_active_innates = false
      return
    end

    list = value.compact.map(&:to_sym)

    @Innates = list.clone
    @active_innates = list.clone
    @fixed_innates  = list.clone
    @form_innates[species_form_key] = list.clone

    @manual_active_innates = true

    puts "Innates= directly set #{self.name}'s Innates to #{list.inspect}"
  end

  def innate_unlock_limit(ignore_lock = false)
    return self.active_innates.size if ignore_lock || !innateLocked? || !self.hasAbilityMutation?
    
    extra_unlocks = @unlocked_innate_count || 0
    return self.active_innates.size if extra_unlocks == -1

    current_method = lockedMethod
    base_count = 0
    
    case current_method
    when :variable
      base_count = $game_variables[Settings::INNATE_PROGRESS_VARIABLE]
    when :level
      lvl_array = Settings::LEVELS_TO_UNLOCK.find { |e| e.is_a?(Array) && e.first == self.species }&.drop(1) || 
                  Settings::LEVELS_TO_UNLOCK.last
      base_count = lvl_array.count { |lvl| self.level >= lvl }
    else
      base_count = 0
    end

    return [0, base_count + extra_unlocks].max
  end

  def unlocked_innates
    limit = self.innate_unlock_limit
    return (self.active_innates || [])[0...limit]
  end

  def set_innate_limits(battler = nil)
    is_wild_or_npc = battler && !battler.pbOwnedByPlayer?
    ignore = onlyLockPlayer? && is_wild_or_npc
    
    limit = self.innate_unlock_limit(ignore)
    
    list = [self.ability_id].flatten.compact
    active_all = self.active_innates || []
    
    active_all.each_with_index do |ability, i|
      break if i >= limit
      list.push(ability)
    end
    
    list.push(:NOABILITY) if list.empty?
    return list
  end

  def abilityAble?(ability)
    return false if !ability
    return true if self.hasAbility?(ability)
    return self.unlocked_innates.include?(ability)
  end
  #===========================================================
  # Aliasing the initialize method
  #===========================================================
  alias_method :original_initialize, :initialize
  def initialize(species, level, owner = $player, withMoves = true, recheck_form = true)
    original_initialize(species, level, owner, withMoves, recheck_form)
    @Innates = []
	  @active_innates = []
    @fixed_innates = []
	  @original_innates = []
	  @form_innates ||= {}
	  @innateset = nil
    @unlocked_innate_count = 0
  end
  #===========================================================
  #Form changing
  #===========================================================
  alias original_form= form=
  def form=(value)
    self.original_form = value
    assign_innate_abilities
  end
end