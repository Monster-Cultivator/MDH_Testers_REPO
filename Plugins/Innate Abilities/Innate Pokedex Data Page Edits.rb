#Edits to the Pokedex Data Page to add a section for innate abilities.
if PluginManager.installed?("[MUI] Pokedex Data Page")
  class PokemonPokedexInfo_Scene
    # 002 Main Page edit ================================================
    #-----------------------------------------------------------------------------
    # Utility for generating lists of data related to a viewed species.
    #-----------------------------------------------------------------------------
    def pbGenerateDataLists(species)
      @data_hash = {
  	  :species => species.id,
        :general => [],
        :habitat => [],
        :shape   => [],
        :stats   => [],
        :egg     => [],
        :family  => []
      }
      #---------------------------------------------------------------------------
      # Determines if this species should display species in compatible Egg Groups.
      #---------------------------------------------------------------------------
      eggSpecies = species
      showCompatible = true
      if species.egg_groups.include?(:Undiscovered)
        evos = species.get_evolutions(true)
        if evos.empty?
          showCompatible = false
        else
          evo = GameData::Species.get(evos[0][0])
          if !evo.egg_groups.include?(:Undiscovered)
            eggSpecies = evo
          else
            showCompatible = false
          end
        end
      end
      #---------------------------------------------------------------------------
      # Sorts all owned species into compatibility lists.
      #---------------------------------------------------------------------------
      family = species.get_family_species
      blacklisted = [:PICHU_2, :FLOETTE_5, :GIMMIGHOUL_1].include?(species.id) ||
                    species.species == :PIKACHU && (8..15).include?(species.form)
      GameData::Species.each do |sp|
        next if !sp.display_species?(@dexlist, species)
        regional_form = sp.form > 0 && sp.is_regional_form?
        base_form = (sp.form > 0) ? GameData::Species.get_species_form(sp.species, sp.base_pokedex_form) : nil
        #-------------------------------------------------------------------------
        # Compatible gender ratio.
        if sp.gender_ratio == species.gender_ratio
          skipForm = base_form && !regional_form && sp.gender_ratio == base_form.gender_ratio
          @data_hash[:general] << sp.id if !skipForm
        end
        #-------------------------------------------------------------------------
        # Compatible habitat.
        if sp.habitat == species.habitat
          skipForm = base_form && !regional_form && sp.habitat == base_form.habitat
          @data_hash[:habitat] << sp.id if !skipForm
        end
        #-------------------------------------------------------------------------
        # Compatible shape & color.
        if sp.color == species.color && sp.shape == species.shape
          skipForm = base_form && !regional_form && sp.color == base_form.color && sp.shape == base_form.shape
          @data_hash[:shape] << sp.id if !skipForm
        end
        #-------------------------------------------------------------------------
        # Compatible base stats.
        if !base_form || regional_form || base_form && sp.base_stats != base_form.base_stats
          GameData::Stat.each_main do |s|
            next if sp.base_stats[s.id] != species.base_stats[s.id]
            @data_hash[:stats] << sp.id
            break
          end
        end
        #-------------------------------------------------------------------------
        # Family members.
        next if blacklisted
        if family.include?(sp.species)
          if sp.species == species.species
            special_form, _check_form, _check_item = pbGetSpecialFormData(sp)
            next if !special_form
          end
          @data_hash[:family] << sp.id
        end
        #-------------------------------------------------------------------------
        # Compatible egg groups.
        if showCompatible
          if base_form && !regional_form && sp.egg_groups == base_form.egg_groups
            next if sp.moves == base_form.moves && sp.tutor_moves == base_form.tutor_moves
          end
          sp.egg_groups.each do |group|
            case group
            when :Ditto
              next if eggSpecies.egg_groups.include?(:Ditto)
              next if eggSpecies.egg_groups.include?(:Undiscovered)
              @data_hash[:egg] << sp.id
            else
              next if eggSpecies.egg_groups.include?(:Undiscovered)
              if eggSpecies.egg_groups.include?(:Ditto)
                next if sp.egg_groups.include?(:Ditto)
                next if sp.egg_groups.include?(:Undiscovered)
                @data_hash[:egg] << sp.id
              elsif eggSpecies.egg_groups.include?(group)
                next if eggSpecies.gender_ratio == :Genderless
                gender = sp.gender_ratio
                next if gender == :Genderless
                next if [:AlwaysMale, :AlwaysFemale].include?(gender) && gender == eggSpecies.gender_ratio
                @data_hash[:egg] << sp.id 
              end
            end
          end
        end
      end
      @data_hash.each_key do |key|
  	  next if key == :species
        list = @data_hash[key].clone
        if key == :family
          sortlist = species.get_family_species
          @data_hash[key] = pbSortDataList(list, sortlist)
        else
          @data_hash[key] = pbSortDataList(list)
        end
      end
      #---------------------------------------------------------------------------
      # Generates list of this species' abilities.
      #---------------------------------------------------------------------------
      @data_hash[:ability] = Hash.new { |key, value| key[value] = [] }
      species.abilities.each do |a|
        next if @data_hash[:ability][0].include?(a)	
        @data_hash[:ability][0] << a
      end
      species.hidden_abilities.each do |a|
        next if @data_hash[:ability][0].include?(a)	
        next if @data_hash[:ability][1].include?(a)	
        @data_hash[:ability][1] << a
      end
  	#Innate abilities add-on
      species.innates.each do |a|
        next if @data_hash[:ability][3].include?(a)
        @data_hash[:ability][3] << a
      end
      case species.id
      when :GRENINJA
        if GameData::Species.exists?(:GRENINJA_1) &&
           GameData::Species.get(:GRENINJA_1).abilities.include?(:BATTLEBOND)
          @data_hash[:ability][2] << :BATTLEBOND
        end
      when :ROCKRUFF
        if GameData::Species.exists?(:ROCKRUFF_2) &&
           GameData::Species.get(:ROCKRUFF_2).abilities.include?(:OWNTEMPO)
          @data_hash[:ability][2] << :OWNTEMPO
        end
      end
      #---------------------------------------------------------------------------
      # Generates list of this species' wild held items.
      #---------------------------------------------------------------------------
      @data_hash[:item] = Hash.new { |key, value| key[value] = [] }
      special_form, _check_form, check_item = pbGetSpecialFormData(species)
      if special_form && check_item
        @data_hash[:item][0] = [check_item]
      else
        species.wild_item_common.each do |i|
          next if @data_hash[:item][0].include?(i)
          @data_hash[:item][0] << i
        end
        species.wild_item_uncommon.each do |i|
          next if @data_hash[:item][0].include?(i)
          next if @data_hash[:item][1].include?(i)
          @data_hash[:item][1] << i
        end
        species.wild_item_rare.each do |i|
          next if @data_hash[:item][0].include?(i)
          next if @data_hash[:item][1].include?(i)
          next if @data_hash[:item][2].include?(i)
          @data_hash[:item][2] << i
        end
      end
    end
  
    # 003 Sub Menu edits ================================================
    def pbFilterDataList(cursor, list)
    species = GameData::Species.get_species_form(@species, @form)
    #---------------------------------------------------------------------------
    # When viewing move lists.
    #---------------------------------------------------------------------------
    if @viewingMoves
      moveID = pbCurrentMoveID
      case cursor
      when :move   # Displays all owned species that may learn the move.
        list = []
        GameData::Species.each do |sp|
          next if !sp.display_species?(@dexlist, species, true)
          regional_form = sp.form > 0 && sp.is_regional_form?
          base_form = (sp.form > 0) ? GameData::Species.get_species_form(sp.species, sp.base_pokedex_form) : nil
          if base_form && !regional_form
            next if sp.moves.sort == base_form.moves.sort && 
                    sp.get_tutor_moves.sort == base_form.get_tutor_moves.sort
          end
          if sp.moves.any? { |m| m[1] == moveID } ||
             sp.get_tutor_moves.include?(moveID) ||
             sp.get_inherited_moves.include?(moveID)
            list.push(sp.id)
          end
        end
        list = pbSortDataList(list)
      when :egg    # Displays only species in a compatible Egg Group.
        compatible = []
        list.each do |s|
          next if s == :RETURN
          sp = GameData::Species.try_get(s)
          if sp && sp.moves.any? { |m| m[1] == moveID } ||
             sp.get_tutor_moves.include?(moveID) ||
             sp.get_inherited_moves.include?(moveID)
            compatible.push(s)
          end
        end
        list = pbSortDataList(compatible)
      end
    #---------------------------------------------------------------------------
    # When viewing ability lists.
    #-------------------------------------------------------------------------
    elsif GameData::Ability.exists?(cursor)
      list = []
      GameData::Species.each do |sp|
        next if !sp.display_species?(@dexlist, species)
        regional_form = sp.form > 0 && sp.is_regional_form?
        base_form = (sp.form > 0) ? GameData::Species.get_species_form(sp.species, sp.base_pokedex_form) : nil
        next if base_form && !regional_form && 
                sp.abilities == base_form.abilities && 
                sp.hidden_abilities == base_form.hidden_abilities &&
				sp.innates == base_form.innates
        if sp.abilities.include?(cursor) || sp.hidden_abilities.include?(cursor) || sp.innates.include?(cursor)
        #if sp.abilities.include?(cursor) || sp.hidden_abilities.include?(cursor)
          list.push(sp.id)
        end
      end
      list = pbSortDataList(list)
    #---------------------------------------------------------------------------
    # When viewing wild held item lists.
    #-------------------------------------------------------------------------
    elsif GameData::Item.exists?(cursor)
      list = []
      GameData::Species.each do |sp|
        next if !sp.display_species?(@dexlist, species)
        regional_form = sp.form > 0 && sp.is_regional_form?
        base_form = (sp.form > 0) ? GameData::Species.get_species_form(sp.species, sp.base_pokedex_form) : nil
        next if base_form && !regional_form && 
                sp.wild_item_common   == base_form.wild_item_common   && 
                sp.wild_item_uncommon == base_form.wild_item_uncommon &&
                sp.wild_item_rare     == base_form.wild_item_rare
        if sp.wild_item_common.include?(cursor) ||
           sp.wild_item_uncommon.include?(cursor) ||
           sp.wild_item_rare.include?(cursor)
          list.push(sp.id)
        end
      end
      list = pbSortDataList(list)
    #---------------------------------------------------------------------------
    # Ensures no compatible Egg Groups if viewed species in Undiscovered group.
    #---------------------------------------------------------------------------
    elsif cursor == :egg && !list.empty?
      list.clear if species.egg_groups.include?(:Undiscovered)
    end
    if list.empty?
      pbPlayBuzzerSE
    else
      list.push(:RETURN)
    end
    return list
    end

    def pbDrawDataList(list, index, cursor = nil)
    cursor = @cursor if !cursor
    case cursor
    when :item    then data = GameData::Item
    when :ability then data = GameData::Ability
    end
    return if list.empty?
    overlay = @sprites["data_overlay"].bitmap
    overlay.clear
    base = Color.new(248, 248, 248)
    shadow = Color.new(72, 72, 72)
    path = Settings::POKEDEX_DATA_PAGE_GRAPHICS_PATH
    textpos = []
    imagepos = [[path + "submenu", 0, 88, 0, 196, 512, 196]]
    last_idx = list.length - 1
    case index
    when 0        then real_idx = 0
    when last_idx then real_idx = (last_idx > 2) ? 2 : index
    else               real_idx = 1
    end
    idx_start = (index > 1) ? index - 1 : 0
    if last_idx - index > 0
      idx_end = idx_start + 2
    else
      idx_start = (last_idx - 2 > 0) ? last_idx - 2 : 0
      idx_end = last_idx
    end
    list[idx_start..idx_end].each_with_index do |id, i|
      idx = 0
      note = ""
      @data_hash[cursor].keys.each do |num|
        next if !@data_hash[cursor][num].include?(id)
        case cursor
        when :item
          case num
          when 0 then note = "Common"
          when 1 then note = "Uncommon"
          when 2 then note = "Rare"
          end
        when :ability
          case num
          when 0 then note = "Slot #{list.index(id) + 1}"
          when 1 then note = "Hidden"
		      when 3 then note = "Innate" #Innate ability add-on
          when 2 then note = "Special"
          end
        end
        idx = num
        break if !nil_or_empty?(note)
      end
      case idx
      when 1 then imagepos.push([path + "submenu", 50, 104 + 42 * i, 0, 392, 412, 40])
      when 2 then imagepos.push([path + "submenu", 50, 104 + 42 * i, 0, 432, 412, 40])
	    when 3 then imagepos.push([path + "submenu", 50, 104 + 42 * i, 0, 472, 412, 40]) #Innate ability add-on
      end
      if index < list.length - 1
        textpos.push([sprintf("%d/%d", index + 1, list.length - 1), 115, 243, :center, base, shadow, :outline])
      end
      if id.is_a?(Symbol)
        textpos.push(
          [_INTL("{1}", note), 115, 114 + 42 * i, :center, base, shadow, :outline],
          [data.get(id).name, 326, 114 + 42 * i, :center, base, shadow, :outline]
        )
      else
        imagepos.push([path + "submenu", 98, 110 + 42 * i, 468, 392, 34, 28])
        textpos.push([id, 326, 114 + 42 * i, :center, base, Color.new(148, 148, 148), :outline])
      end
    end
    imagepos.push([path + "cursor", 184, 98 + 42 * real_idx, 0, 288, 284, 52])
    if index < list.length - 1
      imagepos.push([path + "page_cursor", 248, 236, 0, 70, 76, 32])
    end
    if index > 0
      imagepos.push([path + "page_cursor", 328, 236, 76, 70, 76, 32])
    end
    pbDrawImagePositions(overlay, imagepos)
    pbDrawTextPositions(overlay, textpos)
    case list[index]
    when Symbol
      data_text = DATA_TEXT_TAGS[0] + data.get(list[index]).description
    else
      data_text = DATA_TEXT_TAGS[0] + "Return to species data."
    end
    drawFormattedTextEx(overlay, 34, 294, 446, _INTL("{1}", data_text))
    end

    # 005 Data Messages edit
    def pbDataTextAbilitySource(path, species, overlay, ability)
      t = DATA_TEXT_TAGS
      abilityName = GameData::Ability.get(ability).name
      text = t[2] + "#{abilityName}\n"
      text << t[0] + "Available as "
      #---------------------------------------------------------------------------
      # Natural abilities.
      #---------------------------------------------------------------------------
      if species.abilities.include?(ability)
        case species.abilities.length
        when 1 # Species only has one base ability.
          if species.hidden_abilities.empty? || 
            species.mega_stone || species.mega_move
            text << "the " + t[1] + "only"
          else
            text << "the " + t[1] + "base"
          end
        when 2 # Species has two base abilities.
          if species.abilities[0] == ability
            text << "the " + t[1] + "primary"
          else
            text << "the " + t[1] + "secondary"
          end
        end
      #---------------------------------------------------------------------------
      # Hidden abilities.
      #---------------------------------------------------------------------------
      elsif species.innates.include?(ability)
                text << "a " + t[1] + "innate"
      elsif species.hidden_abilities.include?(ability)
        text << "a " + t[1] + "hidden"
      else
        text << "a " + t[1] + "special" 
      end
      text << t[0] + " ability for this species."
      return text
    end
  end
end