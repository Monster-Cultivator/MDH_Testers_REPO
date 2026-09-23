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

#===============================================================================
# Damage Armor!
#===============================================================================

class Battle::Move
  alias damagearmor_pbInflictHPDamage pbInflictHPDamage

  def pbInflictHPDamage(target)
    if !target.damageState.substitute &&
       target.damageState.hpLost > 0 &&
       target.hasActiveAbility?(:DAMAGEARMOR) &&
       target.form == 0 &&
       target.effects[PBEffects::DamageArmor] > 0

      damage = target.damageState.hpLost
      armor  = target.effects[PBEffects::DamageArmor]

      #-------------------------------------------------------------------------
      # Armor completely absorbs the hit
      #-------------------------------------------------------------------------
      if damage < armor
        target.effects[PBEffects::DamageArmor] -= damage
        target.damageState.hpLost = 0
        return
      end

      #-------------------------------------------------------------------------
      # Armor breaks
      #-------------------------------------------------------------------------
      remaining_damage = damage - armor

      target.effects[PBEffects::DamageArmor] = 0
      target.damageState.hpLost = remaining_damage

      @battle.pbShowAbilitySplash(target)

      target.pbChangeForm(
        1,
        _INTL("{1}'s armor broke!", target.pbThis)
      )

      @battle.pbHideAbilitySplash(target)

      return if remaining_damage <= 0
    end

    damagearmor_pbInflictHPDamage(target)
  end
end

Battle::AbilityEffects::OnSwitchIn.add(:DAMAGEARMOR,
  proc { |ability, battler, battle, switch_in|
    next if battler.form != 0
    battler.effects[PBEffects::DamageArmor] = (battler.totalhp * 0.3).round
  }
)

#===============================================================================
# PROTECTED IMPOSTER
#===============================================================================

Battle::AbilityEffects::DamageCalcFromTargetNonIgnorable.add(:SHELLFIGHT,
  proc { |ability, user, target, move, mults, power, type|
    if move.physicalMove? && user.form == 0 
      mults[:final_damage_multiplier] *= 0.5
    end
    if move.specialMove? && user.form == 1 
      mults[:final_damage_multiplier] *= 0.5
    end
  }
)

#===============================================================================
# Parasitic Love
#
# When this Pokemon damages a poisoned target:
# - Restores 1/16 of its maximum HP.
# - Raises whichever of Defense or Special Defense is currently lower by 1 stage.
# - If both stages are equal, raises whichever actual defensive stat is lower.
#===============================================================================

Battle::AbilityEffects::OnDealingHit.add(:PARASITICLOVE,
  proc { |ability, user, target, move, battle|
    next if target.damageState.calcDamage <= 0
    next if !target.poisoned?
    next if user.fainted?

    battle.pbShowAbilitySplash(user)

    #---------------------------------------------------------------------------
    # Restore HP
    #---------------------------------------------------------------------------
    if user.canHeal?
      heal_amount = (user.totalhp / 8.0).ceil
      user.pbRecoverHP(heal_amount)

      battle.pbDisplay(
        _INTL("{1} fed on the poison coursing through {2}!",
          user.pbThis, target.pbThis)
      )
    end

    #---------------------------------------------------------------------------
    # Determine which defensive stat needs repairing.
    #---------------------------------------------------------------------------

    def_stage  = user.stages[:DEFENSE]
    spdef_stage = user.stages[:SPECIAL_DEFENSE]

    stat_to_raise = nil

    if def_stage < spdef_stage
      stat_to_raise = :DEFENSE
    elsif spdef_stage < def_stage
      stat_to_raise = :SPECIAL_DEFENSE
    else
      # If their stages are equal, compare the actual stats.
      if user.defense < user.spdef
        stat_to_raise = :DEFENSE
      else
        stat_to_raise = :SPECIAL_DEFENSE
      end
    end

    #---------------------------------------------------------------------------
    # Repair the weaker defense.
    #---------------------------------------------------------------------------

    if user.pbCanRaiseStatStage?(stat_to_raise, user)
      user.pbRaiseStatStage(stat_to_raise, 1, user)
    end

    battle.pbHideAbilitySplash(user)
  }
)

#===============================================================================
# Mother's Influence
#
# When the user successfully uses a status move on a poisoned target:
# - Lowers the target's stronger offensive stat by 1 stage.
# - Raises the user's weaker defensive stat by 1 stage.
#
# If stages are tied, actual stats are compared instead.
#===============================================================================

Battle::AbilityEffects::OnDealingHit.add(:MOTHERSINFLUENCE,
  proc { |ability, user, target, move, battle|
    next if target.damageState.calcDamage <= 0
    next if !target.poisoned?
    next if user.fainted?
    
    battle.pbShowAbilitySplash(user)

    #=========================================================================
    # LOWER THE TARGET'S STRONGER OFFENSIVE STAT
    #=========================================================================

    atk_stage   = target.stages[:ATTACK]
    spatk_stage = target.stages[:SPECIAL_ATTACK]

    stat_to_lower = nil

    if atk_stage > spatk_stage
      stat_to_lower = :ATTACK
    elsif spatk_stage > atk_stage
      stat_to_lower = :SPECIAL_ATTACK
    else
      # If stages are equal, compare actual stats.
      if target.attack > target.spatk
        stat_to_lower = :ATTACK
      else
        stat_to_lower = :SPECIAL_ATTACK
      end
    end

    if target.pbCanLowerStatStage?(stat_to_lower, user)
      target.pbLowerStatStage(stat_to_lower, 1, user)
    end

    #=========================================================================
    # RAISE DAUGHTERBEAST'S WEAKER DEFENSIVE STAT
    #=========================================================================

    def_stage   = user.stages[:DEFENSE]
    spdef_stage = user.stages[:SPECIAL_DEFENSE]

    stat_to_raise = nil

    if def_stage < spdef_stage
      stat_to_raise = :DEFENSE
    elsif spdef_stage < def_stage
      stat_to_raise = :SPECIAL_DEFENSE
    else
      # If stages are equal, compare actual stats.
      if user.defense < user.spdef
        stat_to_raise = :DEFENSE
      else
        stat_to_raise = :SPECIAL_DEFENSE
      end
    end

    if user.pbCanRaiseStatStage?(stat_to_raise, user)
      user.pbRaiseStatStage(stat_to_raise, 1, user)
    end

    battle.pbHideAbilitySplash(user)
  }
)