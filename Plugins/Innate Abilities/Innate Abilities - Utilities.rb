def getActiveInnates(pkmn)
  pkmn.active_innates || []
end

MenuHandlers.add(:pokemon_debug_menu, :set_innates, {
  "name"   => _INTL("Set Innates"),
  "parent" => :main,
  "effect" => proc { |pkmn, pkmnid, heldpoke, settingUpBattle, screen|
    cmd = 0
    commands = [
      _INTL("Set Innate Abilities"),
      _INTL("Randomize Defined Innates"),
      _INTL("Randomize Innates MAX"),
      _INTL("Reset Innates")
    ]
    loop do
      innates = pkmn.form_innates[pkmn.form] || pkmn.active_innates || []
      msg = _INTL("Current innates for form {1}: {2}", pkmn.form, innates.join(", "))
      cmd = screen.pbShowCommands(msg, commands, cmd)
      break if cmd < 0
      case cmd
      when 0   # Set Innate Abilities
        params = ChooseNumberParams.new
        params.setRange(1, GameData::Ability.count)
        params.setDefaultValue(1)
        max_innates = screen.pbMessageChooseNumber(_INTL("Set the max number of innates for form {1}: ", pkmn.form), params)
        chosen_innates = []

        max_innates.times do |i|
          new_innate = pbChooseAbilityList
          break if new_innate.nil?
          chosen_innates << new_innate
          screen.pbMessage(_INTL("{1} set as innate {2} for form {3}.", GameData::Ability.get(new_innate).name, i + 1, pkmn.form))
        end

        pkmn.active_innates = chosen_innates
		    pkmn.form_innates[pkmn.form] = pkmn.active_innates
        screen.pbRefreshSingle(pkmnid)

      when 1   # Randomize Defined Innates (Using select_random_innates)
        primary_ability_id = pkmn.ability_id
        max_innates = maxInnates

        pkmn.active_innates = pkmn.select_random_innates(max_innates, primary_ability_id)
        pkmn.form_innates[pkmn.form] = pkmn.active_innates
        screen.pbRefreshSingle(pkmnid)

      when 2   # Randomize Innates MAX (Using max_innate_randomizer)
        primary_ability_id = pkmn.ability_id
        max_innates = maxInnates

        pkmn.active_innates = pkmn.max_innate_randomizer(max_innates, primary_ability_id)
        pkmn.form_innates[pkmn.form] = pkmn.active_innates
        screen.pbRefreshSingle(pkmnid)

      when 3   # Reset Innates
        available_innates = pkmn.getInnateList#.map(&:first)
        params = ChooseNumberParams.new
        params.setRange(1, available_innates.size)
        params.setDefaultValue(1)
        max_innates = screen.pbMessageChooseNumber(_INTL("Reset innates for form {1} to how many?", pkmn.form), params)
		
		# Reset innates for all forms
		pkmn.form_innates.each_key do |form|
		pkmn.form_innates[form] = available_innates.take(max_innates)
		end

        pkmn.active_innates = available_innates.take(max_innates)
        pkmn.form_innates[pkmn.form] = pkmn.active_innates
        screen.pbRefreshSingle(pkmnid)
      end
    end
    next false
  }
})

#Additional utilities for the settings ================================

def randomizerEnabled?
  if Settings::INNATE_RANDOMIZER == true
    if Settings::INNATE_RANDOMIZER_SWITCH != -1
      return $game_switches[Settings::INNATE_RANDOMIZER_SWITCH]
    end
    return true
  end
end

def maxRandomizerEnabled?
  return false unless randomizerEnabled?
  if Settings::MAX_INNATE_RANDOMIZER == true
    if Settings::MAX_INNATE_RANDOMIZRER_SWITCH != -1
      return $game_switches[Settings::MAX_INNATE_RANDOMIZRER_SWITCH]
    end
    return true
  end
end

def alwaysShuffleEnabled?
  if Settings::ALWAYS_SHUFFLE_RANDOMS == true
    if Settings::ALWAYS_SHUFFLE_RANDOMS_SWITCH != -1
      return $game_switches[Settings::ALWAYS_SHUFFLE_RANDOMS_SWITCH]
    end
    return true
  end
end

def maxInnates
  if Settings::INNATE_AMOUNT_VARIABLE > 0
    return $game_variables[Settings::INNATE_AMOUNT_VARIABLE]
  end
  return Settings::INNATE_MAX_AMOUNT
end

def innateLocked?
  if Settings::INNATE_LOCKED_SYSTEM
    if Settings::INNATE_LOCKED_SYSTEM_SWITCH > 0
      return !$game_switches[Settings::INNATE_LOCKED_SYSTEM_SWITCH]
    end
    return true
  end
  return false
end

def lockedMethod
  if Settings::INNATE_LOCKED_METHOD_VARIABLE > 0
    case $game_variables[Settings::INNATE_LOCKED_METHOD_VARIABLE]
    when 0
      return :none
    when 1
      return :level
    when 2
      return :variable
    else
      return Settings::INNATE_LOCKED_METHOD
    end
  end
  return Settings::INNATE_LOCKED_METHOD
end

def onlyLockPlayer?
  if Settings::ONLY_LOCK_PLAYER
    if Settings::ONLY_LOCK_PLAYER_SWITCH > 0
      return $game_switches[Settings::ONLY_LOCK_PLAYER_SWITCH]
    end
    return true
  end
  return false
end