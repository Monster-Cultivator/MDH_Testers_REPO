#===============================================
# Plus/Minus buff
#===============================================
Battle::AbilityEffects::DamageCalcFromUser.add(:MINUS,
  proc { |ability, user, target, move, mults, power, type|
    next if !move.specialMove?
    if user.allAllies.any? { |b| b.hasActiveAbility?(:PLUS) }
      mults[:attack_multiplier] *= 2
    end
  }
)

Battle::AbilityEffects::DamageCalcFromUser.add(:PLUS,
  proc { |ability, user, target, move, mults, power, type|
    next if !move.specialMove?
    if user.allAllies.any? { |b| b.hasActiveAbility?(:MINUS) }
      mults[:attack_multiplier] *= 2
    end
  }
)

=begin
#===============================================
# Mega Launcher Buff (1.5x -> 2x)
#===============================================
Battle::AbilityEffects::DamageCalcFromUser.add(:MEGALAUNCHER,
  proc { |ability, user, target, move, mults, power, type|
    mults[:power_multiplier] *= 2 if move.pulseMove?
  }
)

LISTEN. THIS BUFF, WHILE SEEMINGLY INSIGNIFICANT, WAS FUCKING CRACKED AS SHIT
EVERY SINGLE MEGA LAUNCHER POKEMON (EVEN THE FUCKING SHRIMP) BECAME A GODDAMN MENACE
TRUST ME. THIS IS FOR THE GREATER GOOD.
=end

#===============================================
# Overcoat Buff
#===============================================
Battle::AbilityEffects::DamageCalcFromTarget.add(:OVERCOAT,
  proc { |ability, user, target, move, mults, power, type|
    mults[:final_damage_multiplier] *= 0.8 if move.specialMove?
  }
)

#===============================================
# Battle Armor Buff
# 20% Damage reduction
#===============================================
Battle::AbilityEffects::DamageCalcFromTarget.add(:BATTLEARMOR,
  proc { |ability, user, target, move, mults, power, type|
    mults[:final_damage_multiplier] *= 0.8
  }
)

#===============================================
# Forecast
# Weather Rocks trigger weather
# 1.8x damage multiplier. Please, Castform needs this.
#===============================================
Battle::AbilityEffects::OnSwitchIn.add(:FORECAST,
  proc { |ability, battler, battle, switch_in|
    battle.pbStartWeatherAbility(:Sun, battler)  if battler.item == :HEATROCK 
	  battle.pbStartWeatherAbility(:Rain, battler) if battler.item == :DAMPROCK 
	  battle.pbStartWeatherAbility(:Hail, battler) if battler.item == :ICYROCK  
  }
)
Battle::AbilityEffects::DamageCalcFromUser.add(:FORECAST,
  proc { |ability, user, target, move, mults, power, type|
    mults[:attack_multiplier] *= 1.8
  }
)

#=============================================
# Cute Charm Buff
# 30% when the user OR foe makes contact
#=============================================
# Infatuate when the user makes contact with the foe
Battle::AbilityEffects::OnDealingHit.add(:CUTECHARM,
  proc { |ability, user, target, move, battle|
    next if !move.contactMove?
    next if battle.pbRandom(100) >= 30  # 30% chance to infatuate
    battle.pbShowAbilitySplash(user)
    
    if target.pbCanAttract?(user, Battle::Scene::USE_ABILITY_SPLASH)
      msg = nil
      if !Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}'s {2} infatuated {3}!", user.pbThis, user.abilityName, target.pbThis(true))
      end
      target.pbAttract(user, msg)
    end
    
    battle.pbHideAbilitySplash(user)
  }
)

Battle::AbilityEffects::OnBeingHit.add(:CUTECHARM,
  proc { |ability, user, target, move, battle|
    next if target.fainted?
    next if !move.pbContactMove?(user)
    next if battle.pbRandom(100) >= 30
    battle.pbShowAbilitySplash(target)
    if user.pbCanAttract?(target, Battle::Scene::USE_ABILITY_SPLASH) &&
       user.affectedByContactEffect?(Battle::Scene::USE_ABILITY_SPLASH)
      msg = nil
      if !Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1}'s {2} aroused {3}!", target.pbThis,
           target.abilityName, user.pbThis(true))
      end
      user.pbAttract(target, msg)
    end
    battle.pbHideAbilitySplash(target)
  }
)

# Keen Eye buff: 1.2 accuracy modifier.
Battle::AbilityEffects::AccuracyCalcFromUser.add(:KEENEYE,
  proc { |ability, mods, user, target, move, type|
    mods[:accuracy_multiplier] *= 1.2
  }
)

Battle::AbilityEffects::AccuracyCalcFromUser.copy(:KEENEYE, :ILLUMINATE)
