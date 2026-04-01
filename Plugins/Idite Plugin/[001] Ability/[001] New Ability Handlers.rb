#===============================================================================
# Corruption: Makes all moves Ghost Type
# Spiritomb
#===============================================================================
Battle::AbilityEffects::ModifyMoveBaseType.add(:CORRUPTION,
  proc { |ability, user, move, type|
    next if !GameData::Type.exists?(:GHOST)
    next :GHOST
  }
)

#===============================================================================
# Berserk Gene: Boosts the power of super-effective moves.
# Mewtwo
#===============================================================================
Battle::AbilityEffects::DamageCalcFromUser.add(:BERSERKGENE,
  proc { |ability,user,target,move,mults,baseDmg,type|
    if Effectiveness.super_effective?(target.damageState.typeMod)
      mults[:final_damage_multiplier] *= 1.5
    end
  }
)


#===============================================================================
# Assured Victory: Doubles Special Attack, but lock user into 1 move.
# Mewtwo 2
#===============================================================================
Battle::AbilityEffects::DamageCalcFromUser.add(:ASSUREDVICTORY,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] *= 2 if move.specialMove?
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
# Encore
# Meloetta Formes
#===============================================================================
Battle::AbilityEffects::DamageCalcFromUser.add(:ENCORE,
  proc { |ability, user, target, move, mults, baseDmg, type|
    mults[:power_multiplier] *= 1.2 if move.soundMove? # TURN THIS FUCKING MELOETTA INTO A GODDAMN NUKE BECAUSE YALL DON'T GET ACCESS TO HER HAHAHAHAHAHAHAHAHAHAHAHAHAHA
  }
)

#====================================================
# Fatal Precision
# Super-effective moves can't miss & boosted by 20%.
#====================================================
Battle::AbilityEffects::DamageCalcFromUser.add(:FATALPRECISION,
  proc { |ability, user, target, move, mults, power, type|
    if Effectiveness.super_effective?(target.damageState.typeMod)
      mults[:final_damage_multiplier] *= 1.2
    end
  }
)

Battle::AbilityEffects::AccuracyCalcFromUser.add(:FATALPRECISION,
  proc { |ability, mods, user, target, move, type|
    mods[:base_accuracy] = 0 if Effectiveness.super_effective?(target.damageState.typeMod)
  }
)

#====================================================
# Feline Prowess
# Doubles Special Attack stats.
#====================================================
Battle::AbilityEffects::DamageCalcFromUser.add(:FELINEPROWESS,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] *= 2 if move.specialMove?
  }
)

#====================================================
# Primal Armor
# Decreases Super-effective moves by 50%.
#====================================================
Battle::AbilityEffects::DamageCalcFromTarget.add(:PRIMALARMOR,
  proc { |ability, user, target, move, mults, power, type|
    if Effectiveness.super_effective?(target.damageState.typeMod)
      mults[:final_damage_multiplier] *= 0.5
    end
  }
)

#====================================================
# Mountaineer
# Immune to Rock attacks and stealth rock.
#====================================================
Battle::AbilityEffects::MoveImmunity.add(:MOUNTAINEER,
  proc { |ability, user, target, move, type, battle, show_message|
  next false if type != :ROCK 
  if show_message
      battle.pbShowAbilitySplash(target)
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("It doesn't affect {1}...", target.pbThis(true)))
      else
        battle.pbDisplay(_INTL("{1}'s {2} made {3} ineffective!",
           target.pbThis, target.abilityName, move.name))
      end
      battle.pbHideAbilitySplash(target)
    end
    next true
  }
)

#====================================================
# Self Sufficient
# Recover 1/16 HP at end of turn.
#====================================================
Battle::AbilityEffects::EndOfRoundEffect.add(:SELFSUFFICIENT,
  proc { |ability, battler, battle|
    next if !battler.canHeal?
    battle.pbShowAbilitySplash(battler)
    battler.pbRecoverHP(battler.totalhp / 16)
	if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1}'s HP was restored.", battler.pbThis))
      else
        battle.pbDisplay(_INTL("{1}'s {2} restored its HP.", battler.pbThis, battler.abilityName))
      end
    battle.pbHideAbilitySplash(battler)
  }
)

#====================================================
# Sriker
# Boosts kicking moves by 30%.
#====================================================
Battle::AbilityEffects::DamageCalcFromUser.add(:STRIKER,
  proc { |ability, user, target, move, mults, power, type|
    mults[:power_multiplier] *= 1.5 if move.kickMove?
  }
)

#====================================================
# Blazing Soul
# Gives +1 priority to fire-type moves at full HP.
#====================================================
Battle::AbilityEffects::PriorityChange.add(:BLAZINGSOUL,
  proc { |ability, battler, move, pri|
    next pri + 1 if battler.hp == battler.totalhp && move.type == :FIRE
  }
)

#====================================================
# Sage Power
# Ups Sp.Atk by 50% but only use first used move.
# Nerfed to 20%. This was too busted. Umbreon was one-shotting everything.
#====================================================
Battle::AbilityEffects::DamageCalcFromUser.add(:SAGEPOWER,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] *= 1.2 if move.specialMove?
  }
)
#====================================================
# Phoenix Down
# Revives to half health on first faint.
#====================================================
Battle::AbilityEffects::OnBeingHit.add(:PHOENIXDOWN,
  proc { |ability, user, target, move, battle|
    next if !target.fainted?
    next if target.reborn?
    if !battle.moldBreaker
      target.setReborn
      battle.scene.pbReborn1Battler(target)
      battle.pbDisplayPaused(_INTL("{1} fainted!", target.pbThis))
      pbWait(20/16)
      
      battle.pbShowAbilitySplash(target)
      battle.scene.pbReborn2Battler(target)
      
      target.pbRecoverHP(target.totalhp / 2, false)
      target.pbCureStatus(false)
      target.pbCureConfusion
	  target.pbResetStatStages
      
      battle.pbDisplay(_INTL("{1} rose back to battle!", target.pbThis))
	  battle.pbDisplay(_INTL("{1}'s stats and primary status were reset!", target.pbThis))
      
      battle.pbHideAbilitySplash(target)
    end
  }
)
#====================================================
# Parasitic Waste
# Attacks that poison also drain.
#====================================================
Battle::AbilityEffects::OnDealingHit.add(:PARASITICWASTE,
  proc { |ability, user, target, move, battle|
  next if !["PoisonTarget","BadPoisonTarget","CategoryDependsOnHigherDamagePoisonTarget","HitTwoTimesPoisonTarget"].include?(move.function_code)
  next if !move.damagingMove?
  next if !user.canHeal?
  next if target.damageState.hpLost <= 0
  hpGain = (target.damageState.hpLost / 2.0).round
  battle.pbShowAbilitySplash(user)
  user.pbRecoverHPFromDrain(hpGain, target) 
  battle.pbHideAbilitySplash(user)
  }
)

#====================================================
# EX Moody
# Moody, but WORSE!
#====================================================
Battle::AbilityEffects::EndOfRoundEffect.add(:EXMOODY,
  proc { |ability, battler, battle|
    randomUp = []
    randomDown = []
    if Settings::MECHANICS_GENERATION >= 8
      GameData::Stat.each_main_battle do |s|
        randomUp.push(s.id) if battler.pbCanRaiseStatStage?(s.id, battler)
        randomDown.push(s.id) if battler.pbCanLowerStatStage?(s.id, battler)
      end
    else
      GameData::Stat.each_battle do |s|
        randomUp.push(s.id) if battler.pbCanRaiseStatStage?(s.id, battler)
        randomDown.push(s.id) if battler.pbCanLowerStatStage?(s.id, battler)
      end
    end
    next if randomUp.length == 0 && randomDown.length == 0
    battle.pbShowAbilitySplash(battler)
    if randomUp.length > 0
      r = battle.pbRandom(randomUp.length)
      battler.pbRaiseStatStageByAbility(randomUp[r], 3, battler, false)
      randomDown.delete(randomUp[r])
    end
    if randomDown.length > 0
      r = battle.pbRandom(randomDown.length)
      battler.pbLowerStatStageByAbility(randomDown[r], 1, battler, false)
    end
    battle.pbHideAbilitySplash(battler)
    battler.pbItemStatRestoreCheck if randomDown.length > 0
    battler.pbItemOnStatDropped
  }
)

#================================================
# Striker but for Hybrids
# (Boosts kicking moves by 50%)
#================================================
Battle::AbilityEffects::DamageCalcFromUser.add(:DOWNHEEL,
  proc { |ability, user, target, move, mults, power, type|
    mults[:power_multiplier] *= 1.5 if move.kickMove?
  }
)

#================================================
# Loose Ends
# Sets up Spikes on contact 
#================================================
Battle::AbilityEffects::OnBeingHit.add(:LOOSEEND,
  proc { |ability, user, target, move, battle|
    next if !move.physicalMove?
    next if target.damageState.substitute
    next if target.pbOpposingSide.effects[PBEffects::Spikes] >= 2
    battle.pbShowAbilitySplash(target)
    target.pbOpposingSide.effects[PBEffects::Spikes] += 1
    battle.pbAnimation(:SPIKES, target, target.pbDirectOpposing)
    battle.pbDisplay(_INTL("Spikes were scattered on the ground all around {1}!", target.pbOpposingTeam(true)))
    battle.pbHideAbilitySplash(target)
  }
)

#================================================
# Loose Rocks
# Sets up Stealth Rocks on contact 
#================================================
Battle::AbilityEffects::OnBeingHit.add(:LOOSEROCKS,
  proc { |ability, user, target, move, battle|
    next if !move.physicalMove?
    next if target.damageState.substitute
    next if target.pbOpposingSide.effects[PBEffects::StealthRock] != 0
    battle.pbShowAbilitySplash(target)
    target.pbOpposingSide.effects[PBEffects::StealthRock] = 1
    battle.pbAnimation(:SPIKES, target, target.pbDirectOpposing)
    battle.pbDisplay(_INTL("Pointed stones float in the air all around {1}!", target.pbOpposingTeam(true)))
    battle.pbHideAbilitySplash(target)
  }
)

#================================================
# Jagged Steel
# Sets up Steel Spikes on contact 
#================================================
Battle::AbilityEffects::OnBeingHit.add(:JAGGEDSTEEL,
  proc { |ability, user, target, move, battle|
    next if !move.physicalMove?
    next if target.damageState.substitute
    next if target.pbOpposingSide.effects[PBEffects::Steelsurge] = true
    battle.pbShowAbilitySplash(target)
    target.pbOpposingSide.effects[PBEffects::Steelsurge] = true
    battle.pbAnimation(:SPIKES, target, target.pbDirectOpposing)
    battle.pbDisplay(_INTL("Jagged steel was scattered on the ground all around {1}!", target.pbOpposingTeam(true)))
    battle.pbHideAbilitySplash(target)
  }
)


#===============================================
# Leeching
# Contact moves apply Leech Seed
#===============================================
=begin
Battle::AbilityEffects::OnBeingHit.add(:LEECHING,
  proc { |ability, user, target, move, battle|
    next if !move.pbContactMove?(user)
    next if user.fainted?
    next if target.effects[PBEffects::LeechSeed] <= 0
    battle.pbShowAbilitySplash(target)
    if user.affectedByContactEffect?(Battle::Scene::USE_ABILITY_SPLASH)
      target.effects[PBEffects::LeechSeed] = 1
        battle.pbDisplay(_INTL("{1}'s {2} seeded the opposing side!",
           target.pbThis(true), target.abilityName))
    end
    battle.pbHideAbilitySplash(target)
  }
)
=end 
Battle::AbilityEffects::OnDealingHit.add(:LEECHING, proc { |ability, user, target, move, battle|
  next if !move.contactMove?                              
  next if target.fainted? || user.fainted?                
  next if target.effects[PBEffects::LeechSeed] >= 0       
  next if target.pbHasType?(:GRASS)                      
  next if target.damageState.substitute                   

  battle.pbShowAbilitySplash(user)
  target.effects[PBEffects::LeechSeed] = user.index
  battle.pbAnimation(:LEECHSEED, user, user.pbDirectOpposing)
  battle.pbDisplay(_INTL("{1} was seeded by {2}'s {3}!", target.pbThis, user.pbThis(true), user.abilityName))
  battle.pbHideAbilitySplash(user)
})


#===============================================
# Poison Absorb
# Poison attacks heal you
#===============================================
Battle::AbilityEffects::MoveImmunity.add(:POISONABSORB,
  proc { |ability, user, target, move, type, battle, show_message|
    next target.pbMoveImmunityHealingAbility(user, move, type, :POISON, show_message)
  }
)

#===============================================
# Underhanded
# +1 Priority to Dark type moves
#===============================================
Battle::AbilityEffects::PriorityChange.add(:UNDERHANDED,
  proc { |ability, battler, move, pri|
    next pri + 1 if move.type == :DARK
  }
)

#===============================================
# Eighth Plague
# Doubles the power of Bug type moves
#===============================================
Battle::AbilityEffects::DamageCalcFromUser.add(:EIGHTHPLAGUE,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] *= 2 if type == :BUG
  }
)

#===============================================
# Predator
# KOs restore 20% HP each.
#===============================================
Battle::AbilityEffects::OnEndOfUsingMove.add(:PREDATOR,
  proc { |ability, user, targets, move, battle|
    # Ensure the user has the correct ability
    next unless user.hasActiveAbility?(:PREDATOR)
    
    # Check if all opposing Pokémon are fainted
    next if battle.pbAllFainted?(user.idxOpposingSide)

    # Count the number of Pokémon fainted by the move
    numFainted = 0
    targets.each { |b| numFainted += 1 if b.damageState.fainted }

    # Exit if no Pokémon were fainted
    next if numFainted == 0

    # Heal the user based on the number of Pokémon fainted
    battle.pbShowAbilitySplash(user)
    user.pbRecoverHP((user.totalhp * 0.2 * numFainted), true, true)
    battle.pbDisplay(_INTL("{1} restored a little HP with its {2}!", user.pbThis, user.abilityName)) 
    battle.pbHideAbilitySplash(user)
  }
)

#===============================================
# Soul Siphon/Apex Predator
# KOs restore 20% HP each. [Nerfed from 33% for 0.2.0]
#===============================================
Battle::AbilityEffects::OnEndOfUsingMove.add(:SOULSIPHON,
  proc { |ability, user, targets, move, battle|
    # Ensure the user has the correct ability
    next unless user.hasActiveAbility?(:SOULSIPHON)
    
    # Check if all opposing Pokémon are fainted
    next if battle.pbAllFainted?(user.idxOpposingSide)

    # Count the number of Pokémon fainted by the move
    numFainted = 0
    targets.each { |b| numFainted += 1 if b.damageState.fainted }

    # Exit if no Pokémon were fainted
    next if numFainted == 0

    # Heal the user based on the number of Pokémon fainted
    battle.pbShowAbilitySplash(user)
    user.pbRecoverHP((user.totalhp * numFainted / 4), true, true)
    battle.pbDisplay(_INTL("{1} siphoned HP with its {2}!", user.pbThis, user.abilityName)) 
    battle.pbHideAbilitySplash(user)
  }
)


Battle::AbilityEffects::OnEndOfUsingMove.add(:APEXPREDATOR,
  proc { |ability, user, targets, move, battle|
    # Ensure the user has the correct ability
    next unless user.hasActiveAbility?(:APEXPREDATOR)
    
    # Do not trigger if the user already has full HP
    next if user.hp == user.totalhp

    # Count the number of Pokémon fainted by the move
    numFainted = 0
    targets.each { |b| numFainted += 1 if b.damageState.fainted }

    # Exit if no Pokémon were fainted
    next if numFainted == 0

    # Heal the user based on the number of Pokémon fainted
    battle.pbShowAbilitySplash(user)
    user.pbRecoverHP((user.totalhp * numFainted / 3), true, true)
    battle.pbDisplay(_INTL("{1} restored some HP with its {2}!", user.pbThis, user.abilityName)) 
    battle.pbHideAbilitySplash(user)
  }
)

#===============================================
# Devour
# KOs restore 1/2 of the target's total HP.
#===============================================
Battle::AbilityEffects::OnEndOfUsingMove.add(:DEVOUR,
  proc { |ability, user, targets, move, battle|
    # Ensure the user has the correct ability
    next unless user.hasActiveAbility?(:DEVOUR)

    # Heal based on the total HP of fainted targets
    healing_amount = 0
    targets.each do |target|
      healing_amount += target.totalhp / 2.0 if target.damageState.fainted
    end
    battle.pbShowAbilitySplash(user)
    user.pbRecoverHP(healing_amount.floor, false, false) if healing_amount > 0
    battle.pbDisplay(_INTL("{1} devoured {2}'s carcass!", user.pbThis, opponent.pbThis(true))) 
    battle.pbHideAbilitySplash(user)
  }
)

#===============================================
# Good Ole Days (Pre-Fae)
# Immunity to Fairy type attacks.
#===============================================
Battle::AbilityEffects::MoveImmunity.add(:PREFAE,
  proc { |ability, user, target, move, type, battle, show_message|
    next target.pbMoveImmunityHealingAbility(user, move, type, :FAIRY, show_message)
  }
)

#===============================================
# See No Evil
# Immunity to Dark type attacks.
#===============================================
Battle::AbilityEffects::MoveImmunity.add(:SEENOEVIL,
  proc { |ability, user, target, move, type, battle, show_message|
    next target.pbMoveImmunityHealingAbility(user, move, type, :DARK, show_message)
  }
)

#===============================================
# Heater
# Normal -> Fire.
#===============================================
Battle::AbilityEffects::ModifyMoveBaseType.add(:HEATER,
  proc { |ability, user, move, type|
    next if type != :NORMAL || !GameData::Type.exists?(:FIRE)
    move.powerBoost = true
    next :FIRE
  }
)

#===============================================
# Acid Reflux
# Normal -> Poison.
#===============================================
Battle::AbilityEffects::ModifyMoveBaseType.add(:ACIDREFLUX,
  proc { |ability, user, move, type|
    next if type != :NORMAL || !GameData::Type.exists?(:POISON)
    move.powerBoost = true
    next :POISON
  }
)


#===============================================
# Dimension Warp
# Sets Trick Room on switch-in for 3 turns.
#===============================================
Battle::AbilityEffects::OnSwitchIn.add(:DIMENSIONWARP,
proc { |ability, battler, battle, switch_in|
  if battle.field.effects[PBEffects::TrickRoom] > 0
     battle.pbShowAbilitySplash(battler)
     battle.field.effects[PBEffects::TrickRoom] = 0
     battle.pbAnimation(:TRICKROOM, battler, nil)
     battle.pbDisplay(_INTL("{1} reverted the dimensions!", battler.pbThis))
     battle.pbHideAbilitySplash(battler)
  else
     battle.pbShowAbilitySplash(battler)
     battle.field.effects[PBEffects::TrickRoom] = 3
     battle.pbAnimation(:TRICKROOM, battler, nil)
     battle.pbDisplay(_INTL("{1} twisted the dimensions!", battler.pbThis))
     battle.pbHideAbilitySplash(battler)
    end 
  }
) 

#===============================================
# Dimension Warp EX
# Sets Trick Room on switch-in for 3 turns.
#===============================================
Battle::AbilityEffects::OnSwitchIn.add(:DIMENSIONWARPEX,
proc { |ability, battler, battle, switch_in|
  if battle.field.effects[PBEffects::TrickRoom] > 0
     battle.pbShowAbilitySplash(battler)
     battle.field.effects[PBEffects::TrickRoom] = 0
     battle.pbAnimation(:TRICKROOM, battler, nil)
     battle.pbDisplay(_INTL("{1} reverted the dimensions!", battler.pbThis))
     battle.pbHideAbilitySplash(battler)
  else
     battle.pbShowAbilitySplash(battler)
     battle.field.effects[PBEffects::TrickRoom] = 25
     battle.pbAnimation(:TRICKROOM, battler, nil)
     battle.pbDisplay(_INTL("{1} twisted the dimensions!", battler.pbThis))
     battle.pbHideAbilitySplash(battler)
    end 
  }
) 

#===============================================
# Antartic
# 50% boost to Special Attack in Snow or Hail
#===============================================
Battle::AbilityEffects::DamageCalcFromUser.add(:ANTARTIC,
  proc { |ability, user, target, move, mults, power, type|
    if user.effectiveWeather == :Snow || user.effectiveWeather == :Hail
      mults[:power_multiplier] *= 1.5
    end
  }
)

#===============================================
# Circuit Phantom
# Traps Steel types.
# The other half of this ability is in Battle_Move.rb
# User's Electric type moves are super-effective on Steel types.
#===============================================
Battle::AbilityEffects::TrappingByTarget.add(:CIRCUITPHANTOM,
  proc { |ability, switcher, bearer, battle|
    next true if switcher.pbHasType?(:STEEL)
  }
)

#===============================================
# Invasive
# Ultra Beasts ONLY
# Lowers the target's higher attacking stat on switch-in.
#===============================================
Battle::AbilityEffects::OnSwitchIn.add(:INVASIVE,
  proc { |ability, battler, battle, switch_in|
    oAtk = oSpAtk = 0
    # Sum the Attack and Special Attack stats for all opposing battlers
    battle.allOtherSideBattlers(battler.index).each do |b|
      oAtk   += b.attack
      oSpAtk += b.spatk
    end
    # If Attack is higher, lower the Attack stat
    battle.pbShowAbilitySplash(battler)
    if oAtk > oSpAtk
      battle.allOtherSideBattlers(battler.index).each do |b|
        next if !b.near?(battler)
        check_item = true
        if b.hasActiveAbility?(:CONTRARY)
          check_item = false if b.statStageAtMax?(:ATTACK)
        elsif b.statStageAtMin?(:ATTACK)
          check_item = false
        end
        check_ability = b.pbLowerAttackStatStageIntimidate(battler)
        b.pbAbilitiesOnIntimidated if check_ability
        b.pbItemOnIntimidatedCheck if check_item
      end
    # If Special Attack is higher, lower the Special Attack stat
    else
      battle.allOtherSideBattlers(battler.index).each do |b|
        next if !b.near?(battler)
        check_item = true
        if b.hasActiveAbility?(:CONTRARY)
          check_item = false if b.statStageAtMax?(:SPECIAL_ATTACK)
        elsif b.statStageAtMin?(:SPECIAL_ATTACK)
          check_item = false
        end
        check_ability = b.pbLowerSpecialAttackStatStageIntimidate(battler)
        b.pbAbilitiesOnIntimidated if check_ability
        b.pbItemOnIntimidatedCheck if check_item
      end
    end
    battle.pbHideAbilitySplash(battler)
  }
)

#===============================================
# Cowed
# Oh God, oh fuck. It's SpAtk Intimidate.
#===============================================
Battle::AbilityEffects::OnSwitchIn.add(:COWED,
	proc { |ability, battler, battle, switch_in|
		battle.pbShowAbilitySplash(battler)
		battle.allOtherSideBattlers(battler.index).each do |b|
			next if !b.near?(battler)
			check_item = true
			if b.hasActiveAbility?(:CONTRARY)
				check_item = false if b.statStageAtMax?(:SPECIAL_ATTACK)
				elsif b.statStageAtMin?(:SPECIAL_ATTACK)
				check_item = false
			end
			check_ability = b.pbLowerSpecialAttackStatStageIntimidate(battler)
			b.pbAbilitiesOnIntimidated if check_ability
			b.pbItemOnIntimidatedCheck if check_item
		end
		battle.pbHideAbilitySplash(battler)
	}
)

#===============================================
# Rampage!!! My personal favorite ability out of all of these.
# If the user secures a KO with a move that
# normally requires a recharge turn,
# bypass that recharge.
#===============================================
# Skip recharge turn after using the move
Battle::AbilityEffects::OnEndOfUsingMove.add(:RAMPAGE,
  proc { |ability, user, targets, move, battle|
    # Ensure 'user' is a battler
    next unless user.is_a?(Battle::Battler)

    # Only consider moves that require a recharge (like Hyper Beam)
    next unless user.hasAbility?(:RAMPAGE) && move.chargingTurnMove?

    # Count the number of fainted targets
    numFainted = 0
    targets.each { |b| numFainted += 1 if b.damageState.fainted }

    # If no Pokémon fainted, do nothing
    next if numFainted == 0

    # Mark that the Pokémon KO'd a target, so it skips recharge next turn
    user.effects[PBEffects::HyperBeam] = 0  # Prevent the recharge turn
  }
)

# Step 2: Ensure recharge is properly handled at the end of the round
Battle::AbilityEffects::EndOfRoundEffect.add(:RAMPAGE,
  proc { |ability, battler, battle|
    # If the battler has to recharge (HyperBeam effect), but the RAMPAGE ability is active, skip recharge
    if battler.effects[PBEffects::HyperBeam] > 0
      battler.effects[PBEffects::HyperBeam] = 0  # Skip the recharge
      battle.pbShowAbilitySplash(user)
      battle.pbDisplay(_INTL("{1} is on a rampage!", battler.pbThis))
      battle.pbHideAbilitySplash(user)
    end
  }
)






#===============================================
# Mind Control
# Hypnosis always lands.
#===============================================
Battle::AbilityEffects::AccuracyCalcFromUser.add(:MINDCONTROL,
  proc { |ability, mods, user, target, move, type|
    # If the move is Hypnosis, bypass accuracy checks
    if move.id == :HYPNOSIS || move.id == :DARKVOID
      mods[:base_accuracy] = 0 
    end
  }
)

#===============================================
# Attuned
# Boosts the user's Psychic type attacks.
#===============================================
Battle::AbilityEffects::DamageCalcFromUser.add(:ATTUNED,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] *= 1.5 if type == :PSYCHIC
  }
)

#===============================================
# Distorted
# Boosts the user's Ghost type attacks.
#===============================================
Battle::AbilityEffects::DamageCalcFromUser.add(:DISTORTED,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] *= 1.5 if type == :GHOST
  }
)


#===============================================
# Air Support
# Sets Tailwind for 3 turns upon switch-in.
#===============================================
Battle::AbilityEffects::OnSwitchIn.add(:AIRSUPPORT,
  proc { |ability, battler, battle, switch_in|
    side = battler.pbOwnSide

    battle.pbShowAbilitySplash(battler)

    if side.effects[PBEffects::Tailwind] > 0
      side.effects[PBEffects::Tailwind] = 3
      battle.pbAnimation(:TAILWIND, battler, nil)
      battle.pbDisplay(_INTL("{1} reactivated Tailwind!", battler.pbThis))
    else
      side.effects[PBEffects::Tailwind] = 3
      battle.pbAnimation(:TAILWIND, battler, nil)
      battle.pbDisplay(
        _INTL("{1}'s presence stirred up a strong wind!",
        battler.pbThis)
      )
    end

    battle.pbHideAbilitySplash(battler)
  }
)

#===============================================
# Blues
# Sound attacks heal the user for 1/2 damage dealt.
#===============================================
Battle::AbilityEffects::OnDealingHit.add(:BLUES,
  proc { |ability, user, target, move, battle|
    # Check if the move is a sound-based move and is a damaging move
    next if !move.soundMove?
    next if !move.damagingMove?
    next if !user.canHeal?
    next if target.damageState.hpLost <= 0
    hpGain = (target.damageState.hpLost / 1.2).round
    # Show ability activation
    battle.pbShowAbilitySplash(user)
    user.pbRecoverHPFromDrain(hpGain, target)
    battle.pbHideAbilitySplash(user)
  }
)

#===============================================
# Sticks and Stones
# Chatot, the Xbox party chat was leaked.
#===============================================
Battle::AbilityEffects::DamageCalcFromUser.add(:STICKSANDSTONES,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] *= 2.5 if move.soundMove?
  }
)

#===============================================
# Red Chain
# Lake Trio Unique Ability. Might be TOO busted, but idk.
#===============================================
Battle::AbilityEffects::OnSwitchIn.add(:REDCHAIN,
  proc { |ability, battler, battle|
    battler.eachOpposing do |opponent|
      next unless opponent.pokemon.species_data.has_flag?("Restricted")  # Check if the opponent has the Restricted flag

      # Trap the opponent
      battle.pbShowAbilitySplash(battler)
      opponent.effects[PBEffects::Trapping] = battler
      opponent.effects[PBEffects::TrappingMove] = battler.lastMoveUsed
      battle.pbDisplay(_INTL("{1}'s {2} trapped {3}!", battler.pbThis, battler.abilityName, opponent.pbThis(true)))

      # Lower all of the opponent's stats by one stage
      lowered_stats = [:ATTACK, :DEFENSE, :SPEED, :SPECIAL_ATTACK, :SPECIAL_DEFENSE, :EVASION]
      lowered_stats.each do |stat|
        if opponent.hasActiveAbility?(:CONTRARY)
          # Contrary check. Also want to notify the user that they've been bamboozled.
          if opponent.pbCanRaiseStatStage?(stat, battler, Battle::Scene::USE_ABILITY_SPLASH)
            opponent.pbRaiseStatStage(stat, 1, battler)
            battle.pbDisplay(_INTL("{1}'s Contrary inverted the stat drop!", opponent.pbThis))
          end
        else
          # Normal stat-lowering behavior
          if opponent.pbCanLowerStatStage?(stat, battler, Battle::Scene::USE_ABILITY_SPLASH)
            opponent.pbLowerStatStage(stat, 1, battler)
          end
        end
      end

      battle.pbHideAbilitySplash(battler)
    end
  }
)

#===============================================
# Red Chain
# Lake Trio Unique Ability. Might be TOO busted, but idk.
#===============================================
Battle::AbilityEffects::OnSwitchIn.add(:ANTITHESIS,
  proc { |ability, battler, battle|
    battler.eachOpposing do |opponent|
      next unless opponent.pokemon.species_data.has_flag?("Entities")  # Check if the opponent has the Restricted flag

      # Lower all of the opponent's stats by one stage
      lowered_stats = [:ATTACK, :DEFENSE, :SPEED, :SPECIAL_ATTACK, :SPECIAL_DEFENSE, :EVASION]
      lowered_stats.each do |stat|
        if opponent.hasActiveAbility?(:CONTRARY)
          # Contrary check. Also want to notify the user that they've been bamboozled.
          if opponent.pbCanRaiseStatStage?(stat, battler, Battle::Scene::USE_ABILITY_SPLASH)
            opponent.pbRaiseStatStage(stat, 1, battler)
            battle.pbDisplay(_INTL("{1}'s Contrary inverted the stat drop!", opponent.pbThis))
          end
        else
          # Normal stat-lowering behavior
          if opponent.pbCanLowerStatStage?(stat, battler, Battle::Scene::USE_ABILITY_SPLASH)
            opponent.pbLowerStatStage(stat, 1, battler)
          end
        end
      end

      battle.pbHideAbilitySplash(battler)
    end
  }
)

#==================================================
# Time Warp!
#==================================================
# Charging turns are handled entirely in Move_BaseEffects!! Look there!

# Skip recharge turn for moves like Hyper Beam for the user and allies
Battle::AbilityEffects::EndOfRoundEffect.add(:TIMEWARP,
  proc { |ability, battler, battle|
    # Check if the battler (user) needs to recharge
    if battler.effects[PBEffects::HyperBeam] > 0
      battler.effects[PBEffects::HyperBeam] = 0  # Skip the recharge
      battle.pbShowAbilitySplash(battler)
      battle.pbDisplay(_INTL("{1}'s {2} allows it to avoid recharging!", battler.pbThis, battler.abilityName))
      battle.pbHideAbilitySplash(battler)
    end

    # Check each ally to see if they need to recharge
    battler.allAllies do |ally|
      next unless ally
      if ally.effects[PBEffects::HyperBeam] > 0
        ally.effects[PBEffects::HyperBeam] = 0  # Skip the recharge
        battle.pbShowAbilitySplash(battler)
        battle.pbDisplay(_INTL("{1}'s {2} allows {3} to avoid recharging!", battler.pbThis, battler.abilityName, ally.pbThis))
        battle.pbHideAbilitySplash(battler)
      end
    end
  }
)


#==================================================
# Endless Greed
# Money Gain is handled in Battle_BattleStartAndEnd
# Pickup is handled in Overworld_BattleStarting
#==================================================
Battle::AbilityEffects::DamageCalcFromUser.add(:ENDLESSGREED,
  proc { |ability, user, target, move, mults, baseDmg|
    if move.function == "0A8"   # Function code for Pay Day
      mults[:base_damage_multiplier] *= 1.5
    end
  }
)

#===================================================
# Beast Master Influence
# Causes Disobedience when opponent HP is weak
#===================================================
class Battle::Battler
  def pbObedienceCheck?(choice)
    return true if usingMultiTurnAttack?
    return true if choice[0] != :UseMove
    return true if !@battle.internalBattle
    return true if !@battle.pbOwnedByPlayer?(@index)

    disobedient = false

    # Calculate badge obedience level
    badge_level = 10 * (@battle.pbPlayer.badge_count + 1)
    badge_level = GameData::GrowthRate.max_level if @battle.pbPlayer.badge_count >= 8

    # Check for high-level disobedience (standard obedience logic)
    if Settings::ANY_HIGH_LEVEL_POKEMON_CAN_DISOBEY ||
       (Settings::FOREIGN_HIGH_LEVEL_POKEMON_CAN_DISOBEY && @pokemon.foreign?(@battle.pbPlayer))
      if @level > badge_level
        a = ((@level + badge_level) * @battle.pbRandom(256) / 256).floor
        disobedient |= (a >= badge_level)
      end
    end

    # Check for BeastMasterInfluence disobedience
    ability_battler = @battle.pbCheckOpposingAbility(:BEASTMASTERINFLUENCE, @index)
    if ability_battler
      hp_percentage = (self.hp.to_f / self.totalhp) * 100
      
      disobedience_chance = case hp_percentage
                            # Self-explanatory, but these DO NOT STACK.
                            when 0...33
                              50 # 50% chance below 33% HP
                            when 34...50
                              33 # 33% chance below 50% HP
                            when 51...75
                              10 # 10% chance up to 75% HP
                            else
                              0
                            end

      # Roll for disobedience due to BeastMasterInfluence
      if disobedience_chance > 0 && @battle.pbRandom(100) < disobedience_chance
        # Get trainer name of the Pokémon with BeastMasterInfluence
        trainer_name = @battle.pbGetOwnerName(ability_battler.index)

        # Display ability splash and custom message
        @battle.pbShowAbilitySplash(ability_battler)
        @battle.pbDisplay(_INTL("{1}'s {2} made {3} disobedient!", 
                                trainer_name, 
                                ability_battler.abilityName, 
                                pbThis))
        @battle.pbHideAbilitySplash(ability_battler)
        disobedient = true
      end
    end

    disobedient |= !pbHyperModeObedience(choice[2])
    return true if !disobedient

    # Pokémon is disobedient; make it do something else
    PBDebug.log("[Obedience] #{pbThis} is disobedient.")
    return pbDisobey(choice, badge_level)
  end
end

#=====================================================
# It's back, motherfuckers
#=====================================================
Battle::AbilityEffects::AccuracyCalcFromTarget.add(:NEKONEKORUSH,
  proc { |ability, mods, user, target, move, type|
    mods[:evasion_multiplier] *= 3.33
  }
)



#=====================================================
# Pirate Garb
# 50% Damage Reduction
#=====================================================
Battle::AbilityEffects::DamageCalcFromTarget.add(:PIRATEGARB,
  proc { |ability, user, target, move, mults, power, type|
    mults[:final_damage_multiplier] *= 0.5
  }
)

#=====================================================
# Tremble Before Me
# Attacks against Paralyzed opponents crit.
#=====================================================
Battle::AbilityEffects::CriticalCalcFromUser.add(:TREMBLE,
  proc { |ability, user, target, c|
    next 99 if target.paralyzed?
  }
)
=begin
#============================================
# Flammable (Froslass Drawback)
# Most of this is handled in Move Calcs
# This is for doubling power of super-effective fire moves
#============================================
Battle::AbilityEffects::DamageCalcFromTarget.add(:FLAMMABLE,
  proc { |ability, user, target, move, mults, baseDmg, type|
    next if type != :FIRE
    mod = Effectiveness.calculate(type, target.type1, target.type2)
    if mod > Effectiveness::NORMAL_EFFECTIVE
      # Double the final damage
      mults[:final_damage_multiplier] *= 2
    end
  }
)
=end