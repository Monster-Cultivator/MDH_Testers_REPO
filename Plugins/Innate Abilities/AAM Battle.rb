class Battle
  alias aam_pbCanSwitch? pbCanSwitch?
  def pbCanSwitch?(idxBattler, idxParty = -1, partyScene = nil)
    $aam_trapping=false

    aam_switch =  aam_pbCanSwitch?(idxBattler, idxParty, partyScene)

    $aam_trapping=true
    battler = @battlers[idxBattler]
    # Trapping abilities for All Abilities Mutation
    allOtherSideBattlers(idxBattler).each do |b|
      next if !b.abilityActive?
      if Battle::AbilityEffects.triggerTrappingByTarget(b.ability, battler, b, self)
		$aamName = b.abilityName
        partyScene&.pbDisplay(_INTL("{1}'s {2} prevents switching!",
                                    b.pbThis, $aamName))
        return false
      end
    end
    return aam_switch
  end

  alias aam_pbCanRun? pbCanRun?
  def pbCanRun?(idxBattler)
    $aam_trapping=true
    return aam_pbCanRun?(idxBattler)
  end  

=begin OLD, STUPID VERSION <3 Idite
  alias aam_pbShowAbilitySplash pbShowAbilitySplash
  def pbShowAbilitySplash(battler, delay = false, logTrigger = true, forcedAbility = nil)
    if forcedAbility
      battler.pushForcedSplashAbility(forcedAbility)
    end
    aam_pbShowAbilitySplash(battler, delay, logTrigger)
    if forcedAbility
      battler.popForcedSplashAbility
    end
  end
=end
# New, based version. <3 Idite
unless method_defined?(:innates_fix_pbShowAbilitySplash)
  alias innates_fix_pbShowAbilitySplash pbShowAbilitySplash
  def pbShowAbilitySplash(battler, delay = false, logTrigger = true, forcedAbility = nil)
    forcedAbility ||= battler.currentTriggeredAbility if battler.respond_to?(:currentTriggeredAbility)
    echoln "[AAM] showing splash for #{battler.name} forced=#{forcedAbility.inspect}"
    battler.pushForcedSplashAbility(forcedAbility) if forcedAbility
    innates_fix_pbShowAbilitySplash(battler, delay, logTrigger)
  end
end

unless method_defined?(:innates_fix_pbHideAbilitySplash)
  alias innates_fix_pbHideAbilitySplash pbHideAbilitySplash
  def pbHideAbilitySplash(battler)
    innates_fix_pbHideAbilitySplash(battler)
    battler.forcedSplashAbilityStack&.clear
  end
end

  #Code for once per use abilities by penelope=================================================
  attr_accessor :abils_triggered

  alias fix_initialize initialize
  def initialize(scene, p1, p2, player, opponent)
    fix_initialize(scene, p1, p2, player, opponent)
    @abils_triggered  = [Array.new(@party1.length) { [] }, Array.new(@party2.length) { [] }]
  end
  
  def pbAbilityTriggered?(battler, check_ability = battler.ability)
	return @abils_triggered[battler.index & 1][battler.pokemonIndex].include?(check_ability)
  end

  def pbSetAbilityTrigger(battler, check_ability = battler.ability)
    @abils_triggered[battler.index & 1][battler.pokemonIndex].push(check_ability)
  end

  def switch_limit_ability_trigger?(battler, check_ability)
    if battler.effects[PBEffects::OneUseAbility].include?(check_ability)
      return true
    elsif switch_limit_ability(battler).include?(check_ability)
      battler.effects[PBEffects::OneUseAbility].push(check_ability)
      return false
    end
  end

  def battle_limit_ability_trigger?(battler, check_ability)
    if pbAbilityTriggered?(battler, check_ability)
      return true
    elsif battle_limit_ability(battler).include?(check_ability)
      pbSetAbilityTrigger(battler, check_ability)
      return false
    end
  end

  def switch_limit_ability(battler) # add once per switch ability here
    ret = [:EMBODYASPECT, :EMBODYASPECT_1, :EMBODYASPECT_2, :EMBODYASPECT_3,
           :INTIMIDATE,
           :SCARE]
    #ret = [] if !battler.pbOwnedByPlayer?
    return ret
  end

  def battle_limit_ability(battler) # add once per battle ability here
    ret = [:EMBODYASPECT, :EMBODYASPECT_1, :EMBODYASPECT_2, :EMBODYASPECT_3,
           :INTIMIDATE, :TERAFORMZERO,
           :SCARE]
    #ret = [] if !battler.pbOwnedByPlayer?
    return ret
  end
  #===============================================================
  
end  