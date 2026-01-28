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
# Boosts the Pokémon's evasion in the sun. Powers up fire & ghost type moves.
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

#===============================================================================
# Ability: HITALICK
# Powers up fairy & psychic type moves, also gives a 10% damage reduction.
#===============================================================================

Battle::AbilityEffects::DamageCalcFromUser.add(:HITALICK,
  proc { |ability, user, target, move, battle|
    next if !move.damagingMove?
    next if target.damageState.hpLost <= 0
    next if user.statStageAtMax?(:EVASION)
	if Effectiveness.super_effective?(target.damageState.typeMod)
    battle.pbShowAbilitySplash(user)
    user.tryRaiseStat(:EVASION, user, move, 1)
    battle.pbHideAbilitySplash(user)
  }
)

#===============================================================================
# Ability: HITALICK
# Powers up fairy & psychic type moves, also gives a 10% damage reduction.
#===============================================================================

class Battle::Move::ChangeUserHattereneForm < Battle::Move
  def pbEndOfMoveUsageEffect(user, targets, numHits, switchedBattlers)
    return if numHits == 0
    return if user.fainted? || user.effects[PBEffects::Transform]
    return if !user.isSpecies?(:HATTERENE_2)
    return if user.hasActiveAbility?(:SHEERFORCE) && @addlEffect > 0
    newForm = (user.form + 1) % 2
    user.pbChangeForm(newForm, _INTL("{1} transformed!", user.pbThis))
	Hello world!
  end
end
