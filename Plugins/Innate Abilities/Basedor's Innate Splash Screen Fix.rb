=begin
====================================================================================================
The solution for the splash Abilities comes from creating a back up, which basically overrides the
usual response in case the top of the AbilityStack is nil.
The back up takes anything popped from the stack, It also takes the value of any ability called on the
method hasActiveAbility? which returned true in case a splash is shown outside of the scope of Ability effects.
Theres also 'Motive' which ensures, in the case of a trigger activating inside an 'each.do', that the first
cause of the trigger takes the splash.
Meta file should have (didn't check without those):
Requires   = Innate Abilities
Requires   = Generation 9 Pack
=====================================================================================================
=end

class Battle::Battler
  attr_accessor :BackUpAbility
  attr_accessor :Motive

  def popTriggeredAbility 
    if @abilityTriggerStack || !@abilityTriggerStack.empty?
      self.setBackUp(@abilityTriggerStack.pop)   #Takes the last existing ability to be popped up from the stack, just in case
    end
  end
  
  def clearMotive
    @Motive = nil
  end

  def getBackUp
    return @BackUpAbility
  end

  def setBackUp(ability)
    if @Motive.nil?
      @BackUpAbility = ability
    end
  end

  def setBackUp2(ability, motive)  #Motive can be anything, this is mostly so it triggers on the first ability that it meets requirements instead of the last.
    if @Motive != motive 
      @Motive = motive
      @BackUpAbility = ability
    end
  end

  unless method_defined?(:OLDhasActiveAbility)
    alias OLDhasActiveAbility hasActiveAbility?
  end
  #OLDhasActiveAbility original method is FROM Innate abilities plugin: AAM Battler, ln:128
  def hasActiveAbility?(check_ability, ignore_fainted=false)  #PoisonHeal
    aux = OLDhasActiveAbility(check_ability, ignore_fainted)
    if aux
      self.clearMotive #This entire method has priority over anything, so motives aren't good enough
      if !check_ability.is_a?(Array)
        self.setBackUp(check_ability)  #backs up the ability if it was triggered 
      elsif self.hasAbilityMutation?
        self.setBackUp((@abilityMutationList & check_ability).first)  #backs up the first ability of the list that was triggered
      else
        self.setBackUp(self.ability)   #backs up its ability if it was in the list of valid abilities
      end
    end
    return aux
  end
end

module Battle::AbilityEffects
  #FROM main Script: Battle_AbilityEffects ln:71
  def self.trigger(hash, *args, ret: false)     #Dazzling, Queenly Majesty.
    new_ret = hash.trigger(*args)
    args[1].setBackUp2(args[0],hash) if new_ret   #NEW if the splash were to be used outside of this method, it appears correctly. Just in case the ability effect doesn't include the showsplash
    return (!new_ret.nil?) ? new_ret : ret
  end
  #=================================================================
  #FROM innates abilities plugin, AMM ability Effects, ln:572
  def self.triggerCertainEscapeFromBattle(ability, battler)   #I don't know why the weird structure compared to the rest, I modified it so EMERGENCYEXIT shows while you also have RUNAWAY                                         
	  spotted=false                                         
    battler.abilityMutationList.each do |i|
      if !spotted   #NEW since this one activates when you want to escape, you only care for the first one found
        battler.pushTriggeredAbility(i)
        ret = trigger(CertainEscapeFromBattle, i, battler)
        spotted ||=ret
        battler.popTriggeredAbility   #NEW This line was outside the if clause, which caused the abilityStack to empty since in popped even if it wasn't pushed
      end
    end
    return spotted
  end
end

class Battle  #The back up show in the splash, if forcedAbility is nil
  #Adding more to your code Idite ^.^
  #FROM innates abilities plugin, AMM Battle, ln:41
  unless method_defined?(:innates_fix_pbShowAbilitySplash2)
    alias innates_fix_pbShowAbilitySplash2 pbShowAbilitySplash
    def pbShowAbilitySplash(battler, delay = false, logTrigger = true, forcedAbility = nil)
      forcedAbility ||= battler.currentTriggeredAbility if battler.respond_to?(:currentTriggeredAbility)
      echoln "[AAM] showing splash for #{battler.name} forced=#{forcedAbility.inspect}, backUp=#{battler.getBackUp.inspect}"
      if forcedAbility
        battler.pushForcedSplashAbility(forcedAbility) 
      elsif battler.getBackUp #NEW
        battler.pushForcedSplashAbility(battler.getBackUp) #NEW Comes the backup for the save, if it has something in it
      end
      battler.clearMotive  #NEW Clears the motive, since there was a splash, to let non-motive abilities be backed up
      innates_fix_pbShowAbilitySplash(battler, delay, logTrigger)
    end
  end
end