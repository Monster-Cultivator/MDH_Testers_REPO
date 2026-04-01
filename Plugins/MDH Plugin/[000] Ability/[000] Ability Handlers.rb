Console.echo_warn("LOADING: MyAbilities.rb")

#===============================================================================
# Ability: FIVEMAGICS
# Poison, Psychic, Ghost, Fire, and Electric moves deal 1.2x damage.
#===============================================================================

Battle::AbilityEffects::DamageCalcFromUser.add(:FIVEMAGICS,
  proc { |ability, user, target, move, mults, power, type|
    next unless move.damagingMove?
    next unless [:POISON, :PSYCHIC, :GHOST, :FIRE, :ELECTRIC].include?(type)
    battle = user.battle
    battle.pbShowAbilitySplash(user)
    mults[:final_damage_multiplier] *= 1.2
    battle.pbDisplay(_INTL("{1} has mastered the five magics!", user.pbThis))
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
    if [:Sun, :HarshSun].include?(target.effectiveWeather)
      mods[:evasion_multiplier] *= 1.25
    end
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:KITSUNECROSS,
  proc { |ability, user, target, move, mults, power, type|
    next unless move.damagingMove?
    next unless [:FIRE, :GHOST].include?(type)
    mults[:final_damage_multiplier] *= 1.2
  }
)

#===============================================================================
# Ability: DEVIOUSLICK
# Boosts the Pokémon's evasion on super-effective attacks
#===============================================================================

Battle::AbilityEffects::OnDealingHit.add(:DEVIOUSLICK,
  proc { |ability, user, target, move, battle|
    next if !move.damagingMove?
    next if target.damageState.hpLost <= 0
    next if user.statStageAtMax?(:EVASION)
    next if !Effectiveness.super_effective?(target.damageState.typeMod)
    user.pbRaiseStatStageByAbility(:EVASION, 1, user)
  }
)

#===============================================================================
# Ability: TREBLECLEF
# Changes the user's Sound-Based moves into the Flying-Type.
#===============================================================================

Battle::AbilityEffects::ModifyMoveBaseType.add(:TREBLECLEF,
  proc { |ability, user, move, type|
    next :FLYING if GameData::Type.exists?(:FLYING) && move.soundMove?
  }
)

#===============================================================================
# Ability: ICEFORCE
# Increases Special Attack in Hail.
#===============================================================================

Battle::AbilityEffects::DamageCalcFromUser.add(:ICEFORCE,
  proc { |ability, user, target, move, mults, power, type|
    if move.specialMove? && [:Hail, :Snow].include?(user.effectiveWeather)
      mults[:attack_multiplier] *= 1.5
    end
  }
)

Battle::AbilityEffects::EndOfRoundWeather.add(:ICEFORCE,
  proc { |ability, weather, battler, battle|
    next if ![:Hail, :Snow].include?(weather)
    next if !battler.takesIndirectDamage?
    battle.pbShowAbilitySplash(battler)
    battle.scene.pbDamageAnimation(battler)
    battler.pbReduceHP(battler.totalhp / 8, false)
    battle.pbDisplay(_INTL("{1} was hurt by the Bitter Cold!", battler.pbThis))
    battle.pbHideAbilitySplash(battler)
    battler.pbItemHPHealCheck
  }
)

#===============================================================================
# Dual Wield
# Ceruledge, Lopunny, [Blastoise (Please?)]
#===============================================================================
class Battle::Move
	alias mag_pbNumHits pbNumHits
	def pbNumHits(user, targets)
		mag_pbNumHits(user, targets)
		if user.hasActiveAbility?(:DUALWIELD) && pbDamagingMove? &&
			!chargingTurnMove? && targets.length == 1
        if slicingMove? || pulseMove?
        # Record that Parental Bond applies, to weaken the second attack
				user.effects[PBEffects::ParentalBond] = 3
				return 2
			end
		end
		# Encore
		if user.hasActiveAbility?(:ENCORE) && pbDamagingMove? &&
			!chargingTurnMove? && targets.length == 1
        if soundMove?
				# Record that Parental Bond applies, to weaken the second attack
				user.effects[PBEffects::ParentalBond] = 3
				return 2
			end
		end
		# One-Two
		if user.hasActiveAbility?(:ONETWO) && pbDamagingMove? &&
			!chargingTurnMove? && targets.length == 1
        if punchingMove?
				# Record that Parental Bond applies, to weaken the second attack
				user.effects[PBEffects::ParentalBond] = 3
				return 2
			end
		end
		return 1
	end
end