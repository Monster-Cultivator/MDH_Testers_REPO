module Battle::AbilityEffects
  #Adding a new handler for wandering spirit due to deluxe override
  OnBeingHitSpirit                      = AbilityHandlerHash.new
  $aam_StatusImmunityFromAlly=[] if $aam_StatusImmunityFromAlly.nil?
  $aam_AccuracyCalcFromAlly=[] if $aam_AccuracyCalcFromAlly.nil?
  $aam_DamageCalcFromAlly=[] if $aam_DamageCalcFromAlly.nil?
  $aam_DamageCalcFromTargetAlly=[] if $aam_DamageCalcFromTargetAlly.nil?


#=============================================================================
#To avoid crashes in case the gen 9 pack does not exist
if PluginManager.installed?("Generation 9 Pack")
  def self.triggerOnTypeChange(ability, battler, type)
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      OnTypeChange.trigger(i, battler, type)
      battler.popTriggeredAbility
    end
  end

  def self.triggerOnInflictingStatus(ability, battler, user, status)
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      OnInflictingStatus.trigger(i, battler, user, status)
      battler.popTriggeredAbility
    end
  end

  def self.triggerOnStatusInflicted(ability, battler, user, status)
    if user
        user.abilityMutationList.each do |i|
        user.pushTriggeredAbility(i)
        OnInflictingStatus.trigger(i, user, battler, status)
        user.popTriggeredAbility
      end
    end

    # Abilities on the target
      battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      OnStatusInflicted.trigger(i, battler, user, status)
      battler.popTriggeredAbility
    end
  end

  def self.triggerOnOpposingStatGain(ability, battler, battle, statUps)
    battler.abilityMutationList.each do |mutation|
      battler.pushTriggeredAbility(mutation)
      OnOpposingStatGain.trigger(mutation, battler, battle, statUps)
      battler.popTriggeredAbility
    end
  end

  def self.triggerModifyTypeEffectiveness(ability, user, target, move, battle, effectiveness)
    target.abilityMutationList.each do |i|
      target.pushTriggeredAbility(i)
      effectiveness = trigger(
        ModifyTypeEffectiveness,
        i, user, target, move, battle, effectiveness,
        ret: effectiveness
      )
      target.popTriggeredAbility
    end
    return effectiveness
  end
  
  def self.triggerOnMoveSuccessCheck(ability, user, target, move, battle)
    target.abilityMutationList.each do |i|
      target.pushTriggeredAbility(i)
      OnMoveSuccessCheck.trigger(i, user, target, move, battle)
      target.popTriggeredAbility
    end
  end
end
#=============================================================================

  def self.triggerSpeedCalc(ability, battler, mult)
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      mult = trigger(SpeedCalc, i, battler, mult, ret: mult)
      battler.popTriggeredAbility
    end
    return mult
  end

  def self.triggerWeightCalc(ability, battler, weight)
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      weight = trigger(WeightCalc, i, battler, weight, ret: weight)
      battler.popTriggeredAbility
    end
    return weight 
  end

  #=============================================================================

  def self.triggerOnHPDroppedBelowHalf(ability, user, move_user, battle)
	  spotted=false
    user.abilityMutationList.each do |i|
      user.pushTriggeredAbility(i)
      ret =  trigger(OnHPDroppedBelowHalf, i, user, move_user, battle)
      spotted=true if ret==true
      user.popTriggeredAbility
    end	
    return spotted
  end

  #=============================================================================

  def self.triggerStatusCheckNonIgnorable(ability, battler, status)
	  spotted=false
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      ret =  trigger(StatusCheckNonIgnorable, i, battler, status)
      spotted ||= ret
      battler.popTriggeredAbility 
    end	
	  return spotted
  end

  def self.triggerStatusImmunity(ability, battler, status)
    spotted = false
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      ret = trigger(StatusImmunity, i, battler, status)
      spotted ||= ret
      battler.popTriggeredAbility
    end
    return spotted
  end

  def self.triggerStatusImmunityNonIgnorable(ability, battler, status)
	  spotted=false
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      ret =  trigger(StatusImmunityNonIgnorable, i, battler, status)
        spotted ||= ret
      battler.popTriggeredAbility
    end	
    return spotted
  end
  
  def self.triggerStatusImmunityFromAlly(ability, battler, status)
    spotted = false
    battler.allAllies.each do |b|
      next if !b.hasActiveAbility?(ability.id)
      next if $aam_StatusImmunityFromAlly.include?(b)

      $aam_StatusImmunityFromAlly.push(b)

      b.abilityMutationList.each do |i|
        b.pushTriggeredAbility(i)
        ret = trigger(StatusImmunityFromAlly, i, battler, status)
        spotted ||= ret
        b.popTriggeredAbility
      end
    end
    return spotted
  end

  def self.triggerStatusCure(ability, battler)
	  spotted=false
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      ret =  trigger(StatusCure, i, battler)  #check
      spotted ||= ret
      battler.popTriggeredAbility
    end	
    return spotted
  end
  #=============================================================================

  def self.triggerStatLossImmunity(ability, battler, stat, battle, show_messages)
	  spotted=false
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      ret = trigger(StatLossImmunity, i, battler, stat, battle, show_messages)
      spotted ||= ret
      battler.popTriggeredAbility
    end	
    return spotted
  end

  def self.triggerStatLossImmunityNonIgnorable(ability, battler, stat, battle, show_messages)
	  spotted=false
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      ret =  trigger(StatLossImmunityNonIgnorable, i, battler, stat, battle, show_messages)
      spotted ||= ret
      battler.popTriggeredAbility
    end	
    return spotted
  end

  def self.triggerStatLossImmunityFromAlly(ability, bearer, battler, stat, battle, show_messages)
	  spotted=false
    bearer.abilityMutationList.each do |i|
      bearer.pushTriggeredAbility(i)
      ret =  trigger(StatLossImmunityFromAlly, i, bearer, battler, stat, battle, show_messages)
      spotted ||= ret
      bearer.popTriggeredAbility
    end	
    return spotted
  end

	def self.triggerOnStatGain(ability, battler, stat, user)
		battler.abilityMutationList.each do |i|
		  battler.pushTriggeredAbility(i)
			OnStatGain.trigger(i, battler, stat, user)
      battler.popTriggeredAbility
		end	
	end

  def self.triggerOnStatLoss(ability, battler, stat, user)
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      OnStatLoss.trigger(i, battler, stat, user)
      battler.popTriggeredAbility
    end	
  end

  #=============================================================================

  def self.triggerPriorityChange(ability, battler, move, priority)
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      oldPriority = priority
      priority = trigger(PriorityChange, i, battler, move, priority, ret: priority)
      battler.lastBoostedAbility = i if priority != oldPriority
      battler.popTriggeredAbility
    end	
    return priority
  end

  def self.triggerPriorityBracketChange(ability, battler, battle)
    newprio = 0
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      change = trigger(PriorityBracketChange, i, battler, battle, ret: 0)
      if change < 0 
        newprio = change if newprio < 1
      elsif change > 0
        newprio = change if change > newprio
      end
      battler.popTriggeredAbility
    end	
    return newprio
  end

  def self.triggerPriorityBracketUse(ability, battler, battle)
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      PriorityBracketUse.trigger(i, battler, battle)
      battler.popTriggeredAbility
    end	
  end

  #=============================================================================

  def self.triggerOnFlinch(ability, battler, battle)
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      OnFlinch.trigger(i, battler, battle)
      battler.popTriggeredAbility 
    end	
  end

  def self.triggerMoveBlocking(ability, bearer, user, targets, move, battle)
	  spotted=false
    bearer.abilityMutationList.each do |i|
      bearer.pushTriggeredAbility(i)
      ret =  trigger(MoveBlocking, i, bearer, user, targets, move, battle)
      spotted ||= ret
      bearer.popTriggeredAbility
    end	
    return spotted
  end

  def self.triggerMoveImmunity(ability, user, target, move, type, battle, show_message)
	  spotted=false
    target.abilityMutationList.each do |i|
      target.pushTriggeredAbility(i)
      ret =  trigger(MoveImmunity, i, user, target, move, type, battle, show_message)
      spotted ||= ret
      target.popTriggeredAbility
    end	
    return spotted
  end

  #=============================================================================

  def self.triggerModifyMoveBaseType(ability, user, move, type)
    user.abilityMutationList.each do |i|
      user.pushTriggeredAbility(i)
      oldType = type
      type =  trigger(ModifyMoveBaseType, i, user, move, type, ret: type)
      user.lastBoostedAbility = i if type != oldType
      user.popTriggeredAbility
    end
	  return type
  end

  #=============================================================================

  def self.triggerAccuracyCalcFromUser(ability, mods, user, target, move, type)
    user.abilityMutationList.each do |i|
      user.pushTriggeredAbility(i)
      oldMods = mods.clone
      AccuracyCalcFromUser.trigger(i, mods, user, target, move, type)
      user.lastBoostedAbility = i if mods != oldMods
      user.popTriggeredAbility
    end	
  end

  def self.triggerAccuracyCalcFromAlly(ability, mods, user, target, move, type)
    user.allAllies.each do |b|
      if b.hasActiveAbility?(ability.id) && !$aam_AccuracyCalcFromAlly.include?(b)
        $aam_AccuracyCalcFromAlly.push(b)
        b.abilityMutationList.each do |i|
          b.pushTriggeredAbility(i)
          AccuracyCalcFromAlly.trigger(i, mods, user, target, move, type)
          b.popTriggeredAbility
        end	
      end  
    end  
  end

  def self.triggerAccuracyCalcFromTarget(ability, mods, user, target, move, type)
    target.abilityMutationList.each do |i|
      target.pushTriggeredAbility(i)
      AccuracyCalcFromTarget.trigger(i, mods, user, target, move, type)
      target.popTriggeredAbility
    end	
  end

  #=============================================================================

  def self.triggerDamageCalcFromUser(ability, user, target, move, mults, power, type)
    user.abilityMutationList.each do |i|
      user.pushTriggeredAbility(i)
      before = mults.clone
      DamageCalcFromUser.trigger(i, user, target, move, mults, power, type)
      user.lastBoostedAbility = i if mults != before
      user.popTriggeredAbility
    end	
  end

  def self.triggerDamageCalcFromAlly(ability, user, target, move, mults, power, type)
    user.allAllies.each do |b|
      if b.hasActiveAbility?(ability.id) && !$aam_DamageCalcFromAlly.include?(b)
        $aam_DamageCalcFromAlly.push(b)
        b.abilityMutationList.each do |i|
          b.pushTriggeredAbility(i)
          DamageCalcFromAlly.trigger(i, user, target, move, mults, power, type)
          b.popTriggeredAbility
        end	
      end  
    end 
  end

  def self.triggerDamageCalcFromTarget(ability, user, target, move, mults, power, type)
    target.abilityMutationList.each do |i|
      target.pushTriggeredAbility(i)
      DamageCalcFromTarget.trigger(i, user, target, move, mults, power, type)
      target.popTriggeredAbility
    end	
  end

  def self.triggerDamageCalcFromTargetNonIgnorable(ability, user, target, move, mults, power, type)
    target.abilityMutationList.each do |i|
      target.pushTriggeredAbility(i)
      DamageCalcFromTargetNonIgnorable.trigger(i, user, target, move, mults, power, type)
      target.popTriggeredAbility
    end	
  end

  def self.triggerDamageCalcFromTargetAlly(ability, user, target, move, mults, power, type)
    target.allAllies.each do |b|
      if b.hasActiveAbility?(ability.id) && !$aam_DamageCalcFromTargetAlly.include?(b)
        $aam_DamageCalcFromTargetAlly.push(b)
        b.abilityMutationList.each do |i|
          b.pushTriggeredAbility(i)
          DamageCalcFromTargetAlly.trigger(i, user, target, move, mults, power, type)
          b.popTriggeredAbility
        end	
      end  
    end 
  end

  def self.triggerCriticalCalcFromUser(ability, user, target, crit_stage)
    user.abilityMutationList.each do |i|
      user.pushTriggeredAbility(i)
      crit_stage =  trigger(CriticalCalcFromUser, i, user, target, crit_stage, ret: crit_stage)
      user.popTriggeredAbility
    end	
	  return crit_stage
  end

  def self.triggerCriticalCalcFromTarget(ability, user, target, crit_stage)
    vuln=0
    target.abilityMutationList.each do |i|
      ret =  trigger(CriticalCalcFromTarget, i, user, target, crit_stage, ret: crit_stage)
      if ret<0
        target.pushTriggeredAbility(i)
        vuln=ret 
      elsif ret>0
        target.pushTriggeredAbility(i)
        vuln=ret if vuln>=0 && ret>vuln
      end
      target.popTriggeredAbility
    end	
    return vuln
  end

  #=============================================================================

  def self.triggerOnBeingHit(ability, user, target, move, battle)
    target.abilityMutationList.each do |i|
      target.pushTriggeredAbility(i)
      if i == :WANDERINGSPIRIT
        OnBeingHitSpirit.trigger(i, user, target, move, battle)
      else
        OnBeingHit.trigger(i, user, target, move, battle)
      end
      target.popTriggeredAbility
    end	
  end

  def self.triggerOnDealingHit(ability, user, target, move, battle)
    user.abilityMutationList.each do |i|
      user.pushTriggeredAbility(i)
      OnDealingHit.trigger(i, user, target, move, battle)
      user.popTriggeredAbility
    end	
  end

  #=============================================================================

  def self.triggerOnEndOfUsingMove(ability, user, targets, move, battle)
    user.abilityMutationList.each do |i|
      user.pushTriggeredAbility(i)
      OnEndOfUsingMove.trigger(i, user, targets, move, battle)
      user.popTriggeredAbility
    end	
  end

  def self.triggerAfterMoveUseFromTarget(ability, target, user, move, switched_battlers, battle)
    target.abilityMutationList.each do |i|
      target.pushTriggeredAbility(i)
      AfterMoveUseFromTarget.trigger(i, target, user, move, switched_battlers, battle)
      target.popTriggeredAbility
    end	
  end

  #=============================================================================

  def self.triggerEndOfRoundWeather(ability, weather, battler, battle)
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      EndOfRoundWeather.trigger(i, weather, battler, battle)
      battler.popTriggeredAbility
    end	
  end

  def self.triggerEndOfRoundHealing(ability, battler, battle)
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      EndOfRoundHealing.trigger(i, battler, battle)
      battler.popTriggeredAbility
    end	
  end

  def self.triggerEndOfRoundEffect(ability, battler, battle)
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      EndOfRoundEffect.trigger(i, battler, battle)
      battler.popTriggeredAbility
    end	
  end

  def self.triggerEndOfRoundGainItem(ability, battler, battle)
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      EndOfRoundGainItem.trigger(i, battler, battle)
      battler.popTriggeredAbility
    end	
  end

  #=============================================================================

  def self.triggerCertainSwitching(ability, switcher, battle)
	  spotted=false
    switcher.abilityMutationList.each do |i|
      switcher.pushTriggeredAbility(i)
      ret =  trigger(CertainSwitching, i, switcher, battle)
      spotted ||= ret
      switcher.popTriggeredAbility
    end	
    return spotted
  end

  def self.triggerTrappingByTarget(ability, switcher, bearer, battle)
	  spotted=false
    bearer.abilityMutationList.each do |i|
      ret =  trigger(TrappingByTarget, i, switcher, bearer, battle)
      if ret==true
        spotted=true 
        bearer.pushTriggeredAbility(i)
      end
      bearer.popTriggeredAbility
    end	
    if spotted
      if $aam_trapping
        return true 
      end
      return false
    else  
      return false
    end   
  end

  def self.triggerOnSwitchIn(ability, battler, battle, switch_in = false)
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      OnSwitchIn.trigger(i, battler, battle, switch_in)
      battler.popTriggeredAbility
    end	
  end

  def self.triggerOnSwitchOut(ability, battler, end_of_battle)
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      OnSwitchOut.trigger(i, battler, end_of_battle)
      battler.popTriggeredAbility
    end  
  end

  def self.triggerChangeOnBattlerFainting(ability, battler, fainted, battle)
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      ChangeOnBattlerFainting.trigger(i, battler, fainted, battle)
      battler.popTriggeredAbility
    end	
  end

  def self.triggerOnBattlerFainting(ability, battler, fainted, battle)
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      OnBattlerFainting.trigger(i, battler, fainted, battle)
      battler.popTriggeredAbility
    end	
  end

  def self.triggerOnTerrainChange(ability, battler, battle, ability_changed)
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      OnTerrainChange.trigger(i, battler, battle, ability_changed)
      battler.popTriggeredAbility
    end	
  end

  def self.triggerOnIntimidated(ability, battler, battle)
    battler.abilityMutationList.each do |i|
      battler.pushTriggeredAbility(i)
      OnIntimidated.trigger(i, battler, battle)
      battler.popTriggeredAbility
    end	
  end

  #=============================================================================

  def self.triggerCertainEscapeFromBattle(ability, battler)
	  spotted=false
    battler.abilityMutationList.each do |i|
      ret =  trigger(CertainEscapeFromBattle, i, battler)
      if ret==true
        spotted=true 
        battler.pushTriggeredAbility(i)
      end
      battler.popTriggeredAbility  
    end	
    return spotted
  end
end  

###############################
# Ability Combos Section
###############################

# Immunity x Toxic Boost/Poison Heal:  Poison Is not cured.
Battle::AbilityEffects::StatusCure.add(:IMMUNITY,
  proc { |ability, battler|
    next if battler.status != :POISON
	  next if battler.abilityMutationList.include?(:TOXICBOOST)
	  next if battler.abilityMutationList.include?(:POISONHEAL)
    battler.battle.pbShowAbilitySplash(battler)
    battler.pbCureStatus(Battle::Scene::USE_ABILITY_SPLASH)
    if !Battle::Scene::USE_ABILITY_SPLASH
      battler.battle.pbDisplay(_INTL("{1}'s {2} cured its poisoning!", battler.pbThis, battler.abilityName))
    end
    battler.battle.pbHideAbilitySplash(battler)
  }
)


Battle::AbilityEffects::OnSwitchOut.add(:IMMUNITY,
  proc { |ability, battler, endOfBattle|
    next if battler.status != :POISON
    next if battler.abilityMutationList.include?(:TOXICBOOST)
    next if battler.abilityMutationList.include?(:POISONHEAL)
    PBDebug.log("[Ability triggered] #{battler.pbThis}'s #{battler.abilityName}")
    battler.status = :NONE
  }
)
