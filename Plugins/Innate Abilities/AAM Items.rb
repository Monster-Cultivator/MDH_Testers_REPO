ItemHandlers::UseOnPokemon.add(:INNATESHUFFLER, proc { |item, qty, pokemon, scene, screen, msg|
  if scene.pbConfirm(_INTL("Do you want to shuffle {1}'s Innates?", pkmn.name))
  # Reset innates for all forms
  available_innates = pokemon.getInnateList.flatten.uniq # Flatten if it returns nested arrays
  pokemon.form_innates.each_key do |form|
    pokemon.form_innates[form] = available_innates.take(maxInnates)
  end

  # If randomization is enabled, apply the appropriate randomizer
  if randomizerEnabled?
    if maxRandomizerEnabled?
      # Use max_innate_randomizer for fully randomized innates
      pokemon.active_innates = pokemon.max_innate_randomizer(maxInnates, pokemon.ability_id)
    else
      # Use select_random_innates for possible randomized innates
      pokemon.active_innates = pokemon.select_random_innates(maxInnates, pokemon.ability_id)
    end
  end

  # Update the form's innates with the new active ones
  pokemon.form_innates[pokemon.form] = pokemon.active_innates

  # Display message indicating innates were shuffled
  scene.pbDisplay(_INTL("{1} has shuffled its innates!", pokemon.name))
  next true
  end
  next false
})

ItemHandlers::UseOnPokemon.add(:INNATEUNLOCKER, proc { |item, qty, pokemon, scene, screen, msg|
  # 1. Check if the system is even active. If not, don't use the item.
  if !innateLocked?
    scene.pbDisplay(_INTL("The innates are already fully unlocked for {1}!", pokemon.name))
    next false
  end
  # Check if the Pokemon already has all innates unlocked.
  # If unlocked_innate_count is already 3 (or the max), or is -1, it's maxed.
  max_innates = pokemon.active_innates.size
  if pokemon.unlocked_innate_count == -1 || pokemon.unlocked_innate_count >= max_innates
    scene.pbDisplay(_INTL("{1}'s already at the top of it's ability power!", pokemon.name))
    next false
  end

  # Confirm and apply the boost
  if scene.pbConfirm(_INTL("Would you like to expand {1}'s innate capacity?", pokemon.name))
    pokemon.unlocked_innate_count += 1
    
    scene.pbDisplay(_INTL("{1} has acces to more innate abilities!", pokemon.name))
    next true
  end
  next false
})

ItemHandlers::UseOnPokemon.add(:ABILITYCAPSULE, proc { |item, qty, pkmn, scene|
  if scene.pbConfirm(_INTL("Do you want to change {1}'s Ability?", pkmn.name))
    abils = pkmn.getAbilityList
    abil1 = nil
    abil2 = nil
    abils.each do |i|
      abil1 = i[0] if i[1] == 0
      abil2 = i[0] if i[1] == 1
    end
    if abil1.nil? || abil2.nil? || pkmn.hasHiddenAbility? || pkmn.isSpecies?(:ZYGARDE)
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end

    # Change the ability
    newabil = (pkmn.ability_index + 1) % 2
    newabilname = GameData::Ability.get((newabil == 0) ? abil1 : abil2).name
    pkmn.ability_index = newabil
    pkmn.ability = nil
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1}'s Ability changed! Its Ability is now {2}!", pkmn.name, newabilname))

    # Reset all forms' innates and re-roll them
    #pkmn.form_innates.each_key do |form|
    #  pkmn.reset_innates_for_form(form)  # Custom method to reset and re-roll innates for the form
    #end
    pkmn.form_innates.clear

    next true
  end
  next false
})

ItemHandlers::UseOnPokemon.add(:ABILITYPATCH, proc { |item, qty, pkmn, scene|
  if scene.pbConfirm(_INTL("Do you want to change {1}'s Ability?", pkmn.name))
    abils = pkmn.getAbilityList
    new_ability_id = nil
    abils.each { |a| new_ability_id = a[0] if a[1] == 2 }

    if !new_ability_id || pkmn.hasHiddenAbility? || pkmn.isSpecies?(:ZYGARDE)
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end

    # Change the ability to the hidden one
    new_ability_name = GameData::Ability.get(new_ability_id).name
    pkmn.ability_index = 2
    pkmn.ability = nil

    # Clear cached innates so they are re-rolled next time they are needed
    pkmn.form_innates.clear if pkmn.respond_to?(:form_innates) && pkmn.form_innates

    scene.pbRefresh
    scene.pbDisplay(_INTL("{1}'s Ability changed! Its Ability is now {2}!", pkmn.name, new_ability_name))

    next true
  end
  next false
})
