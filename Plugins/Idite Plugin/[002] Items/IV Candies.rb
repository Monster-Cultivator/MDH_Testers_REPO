#===============================================================================
# Functions to handle IV Raising Candies.
#===============================================================================
# Handles directly raising the IV
def pbRaiseIndividualValues(pkmn, stat, ivGain = 3)
  stat = GameData::Stat.get(stat).id
  return 0 if pkmn.iv[stat] >= Pokemon::IV_STAT_LIMIT
  ivGain = ivGain.clamp(0, Pokemon::IV_STAT_LIMIT - pkmn.iv[stat])
  if ivGain > 0
    pkmn.iv[stat] += ivGain
    pkmn.calc_stats
  end
  return ivGain
end

#Conforms to 31 (or custom) IV point limit
def pbMaxUsesOfIVRaisingItem(stat, amt_per_use, pkmn)
  amt_can_gain = Pokemon::IV_STAT_LIMIT - pkmn.iv[stat]
  return [(amt_can_gain.to_f / amt_per_use).ceil, 1].max
end

# Method called when using candy
def pbUseIVRaisingItem(stat, amt_per_use, qty, pkmn, happiness_type, scene)
  ret = true
  qty.times do |i|
    if pbRaiseIndividualValues(pkmn, stat, amt_per_use) > 0
      pkmn.changeHappiness(happiness_type)
    else
      ret = false if i == 0
      break
    end
  end
  if !ret
    scene.pbDisplay(_INTL("It won't have any effect."))
    return false
  end
  pbSEPlay("Use item in party")
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s {2} IV increased.", pkmn.name, GameData::Stat.get(stat).name))
  return true
end

#===============================================================================
# Function handling the lowering of Individual Values
#===============================================================================
def pbLowerIndividualValues(pkmn, stat)
  stat = GameData::Stat.get(stat).id
  return 0 if pkmn.iv[stat] == 0
  
  iv_reduced = pkmn.iv[stat]
  pkmn.iv[stat] = 0
  pkmn.calc_stats
  
  return iv_reduced
end

def pbUseIVLoweringItem(stat, pkmn, happiness_type, scene)
  if pbLowerIndividualValues(pkmn, stat) > 0
    pkmn.changeHappiness(happiness_type)
    pbSEPlay("Use item in party")
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1}'s {2} individual values were reset to zero.", 
                          pkmn.name, GameData::Stat.get(stat).name))
    return true
  else
    scene.pbDisplay(_INTL("It won't have any effect."))
    return false
  end
end

#===============================================================================
# Item Handlers for IV Candies
#===============================================================================

# HP
ItemHandlers::UseOnPokemonMaximum.add(:HEALTHCANDY, proc { |item, pkmn|
  next pbMaxUsesOfIVRaisingItem(:HP, 3, pkmn)
})

ItemHandlers::UseOnPokemon.add(:HEALTHCANDY, proc { |item, qty, pkmn, scene|
  next pbUseIVRaisingItem(:HP, 3, qty, pkmn, "vitamin", scene)
})


# Attack
ItemHandlers::UseOnPokemonMaximum.add(:MIGHTYCANDY, proc { |item, pkmn|
  next pbMaxUsesOfIVRaisingItem(:ATTACK, 3, pkmn)
})

ItemHandlers::UseOnPokemon.add(:MIGHTYCANDY, proc { |item, qty, pkmn, scene|
  next pbUseIVRaisingItem(:ATTACK, 3, qty, pkmn, "vitamin", scene)
})


# Defense
ItemHandlers::UseOnPokemonMaximum.add(:TOUGHCANDY, proc { |item, pkmn|
  next pbMaxUsesOfIVRaisingItem(:DEFENSE, 3, pkmn)
})

ItemHandlers::UseOnPokemon.add(:TOUGHCANDY, proc { |item, qty, pkmn, scene|
  next pbUseIVRaisingItem(:DEFENSE, 3, qty, pkmn, "vitamin", scene)
})


# SpAtk
ItemHandlers::UseOnPokemonMaximum.add(:SMARTCANDY, proc { |item, pkmn|
  next pbMaxUsesOfIVRaisingItem(:SPECIAL_ATTACK, 3, pkmn)
})

ItemHandlers::UseOnPokemon.add(:SMARTCANDY, proc { |item, qty, pkmn, scene|
  next pbUseIVRaisingItem(:SPECIAL_ATTACK, 3, qty, pkmn, "vitamin", scene)
})


# SpDef
ItemHandlers::UseOnPokemonMaximum.add(:COURAGECANDY, proc { |item, pkmn|
  next pbMaxUsesOfIVRaisingItem(:SPECIAL_DEFENSE, 3, pkmn)
})

ItemHandlers::UseOnPokemon.add(:COURAGECANDY, proc { |item, qty, pkmn, scene|
  next pbUseIVRaisingItem(:SPECIAL_DEFENSE, 3, qty, pkmn, "vitamin", scene)
})


# Speed
ItemHandlers::UseOnPokemonMaximum.add(:QUICKCANDY, proc { |item, pkmn|
  next pbMaxUsesOfIVRaisingItem(:SPEED, 3, pkmn)
})

ItemHandlers::UseOnPokemon.add(:QUICKCANDY, proc { |item, qty, pkmn, scene|
  next pbUseIVRaisingItem(:SPEED, 3, qty, pkmn, "vitamin", scene)
})

#===============================================================================
# Item handlers for IV-lowering vitamins
#===============================================================================

# Sickly Candy
ItemHandlers::UseOnPokemon.add(:SICKLYCANDY, proc { |item, qty, pkmn, scene|
  next pbUseIVLoweringItem(:HP, pkmn, "vitamin", scene)
})

# Weak Candy
ItemHandlers::UseOnPokemon.add(:WEAKCANDY, proc { |item, qty, pkmn, scene|
  next pbUseIVLoweringItem(:ATTACK, pkmn, "vitamin", scene)
})

# Brittle Candy
ItemHandlers::UseOnPokemon.add(:BRITTLECANDY, proc { |item, qty, pkmn, scene|
  next pbUseIVLoweringItem(:DEFENSE, pkmn, "vitamin", scene)
})

# Numb Candy
ItemHandlers::UseOnPokemon.add(:NUMBCANDY, proc { |item, qty, pkmn, scene|
  next pbUseIVLoweringItem(:SPECIAL_ATTACK, pkmn, "vitamin", scene)
})

# Coward Candy
ItemHandlers::UseOnPokemon.add(:COWARDCANDY, proc { |item, qty, pkmn, scene|
  next pbUseIVLoweringItem(:SPECIAL_DEFENSE, pkmn, "vitamin", scene)
})

# Slow Candy
ItemHandlers::UseOnPokemon.add(:SLOWCANDY, proc { |item, qty, pkmn, scene|
  next pbUseIVLoweringItem(:SPEED, pkmn, "vitamin", scene)
})