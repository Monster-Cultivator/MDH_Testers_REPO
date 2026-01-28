#===============================================================================
# Ability: FIVEMAGICS
# Poison, Psychic, Ghost, Fire, and Electric moves deal 1.2x damage.
#===============================================================================

Battle::AbilityEffects::DamageCalcFromUser.add(:FIVEMAGICS,
  proc { |ability, user, target, move, mults, power, type|
    next if !move.damagingMove?
    next unless [:POISON, :PSYCHIC, :GHOST, :FIRE, :ELECTRIC].include?(type)
    battle.pbShowAbilitySplash(user)
	mults[:final_damage_multiplier] *= 1.2
	battle.pbDisplay(_INTL("{1} has mastered {2}", user.pbThis))
	battle.pbHideAbilitySplash(user)
  }
)

#===============================================================================
# Ability: TRUEEMBRACE
# Powers up fairy & psychic type moves, also gives a 10% damage reduction.
#===============================================================================

# 1.2x damage for the user's Psychic and fairy moves
Battle::AbilityEffects::DamageCalcFromUser.add(:TRUEEMBRACE,
  proc { |ability, user, target, move, mults, power, type|
    next if !move.damagingMove?
    next unless [:PSYCHIC, :FAIRY].include?(type)
    mults[:final_damage_multiplier] *= 1.2
  }
)

# 10% damage resistance 
Battle::AbilityEffects::DamageCalcFromTarget.add(:TRUEEMBRACE,
  proc { |ability, user, target, move, mults, power, type|
    next unless move.damagingMove?
    mults[:final_damage_multiplier] *= 0.9
  }
)

#===============================================================================
# Ability: KITSUNECROSS
# Powers up fairy & psychic type moves, also gives a 10% damage reduction.
#===============================================================================

Battle::AbilityEffects::AccuracyCalcFromTarget.add(:KITSUNECROSS,
  proc { |ability, mods, user, target, move, type|
    mods[:evasion_multiplier] *= 1.25 if target.effectiveWeather == :Sun, :HarshSun
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:KITSUNECROSS,
  proc { |ability, user, target, move, mults, power, type|
    next if !move.damagingMove?
    next unless [:FIRE, GHOST].include?(type)
    mults[:final_damage_multiplier] *= 1.2
  }
)