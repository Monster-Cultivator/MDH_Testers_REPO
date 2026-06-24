
module PBEffects
  #===========================================================================
  # These effects apply to a battler
  #===========================================================================
  #IMPORTANT: Set Trace to an unused Effect ID in your game.
  ############################################################################
  Trace  = 1000
end   
  

class Battle::Battler
  attr_accessor :abilityMutationList
  attr_accessor :forcedSplashAbilityStack
  attr_accessor :abilityTriggerStack
  attr_accessor :lastBoostedAbility
  
  def hasAbilityMutation?
    return (@pokemon) ? @pokemon.hasAbilityMutation? : false
  end
  
  # Gen 9 Pack Compatibility
  def affectedByMoldBreaker?
    return @battle.moldBreaker && !hasActiveItem?(:ABILITYSHIELD)
  end
  
  def ability=(value)
    new_ability = GameData::Ability.try_get(value)
    @ability_id = (new_ability) ? new_ability.id : nil
    if @ability_id 
      if self.hasAbilityMutation?
        @abilityMutationList.unshift(@ability_id)
        @abilityMutationList = @abilityMutationList|[]
      else  
        @abilityMutationList[0]=@ability_id 
      end  
    end  
  end

  def pushTriggeredAbility(ability)
    @abilityTriggerStack ||= []
    @abilityTriggerStack.push(ability)
  end

  def popTriggeredAbility
    @abilityTriggerStack.pop if @abilityTriggerStack
  end

  def currentTriggeredAbility
    return nil if !@abilityTriggerStack || @abilityTriggerStack.empty?
    @abilityTriggerStack.last
  end

  alias abilityMutations_pbInitPokemon pbInitPokemon
	def pbInitPokemon(pkmn, idxParty)
		abilityMutations_pbInitPokemon(pkmn, idxParty)

		# Initialize the innate abilities if not already set
		pkmn.assign_innate_abilities if pkmn.active_innates.empty?
		# Set the ability mutation list using the new method
		@abilityMutationList = pkmn.set_innate_limits(self)
    @forcedSplashAbilityStack ||= []
	end
  
  alias abilityMutations_pbInitEffects pbInitEffects
  def pbInitEffects(batonPass)
    abilityMutations_pbInitEffects(batonPass)
	  @effects[PBEffects::Trace] = false   #DemICE   AAM edit
  end

  def pushForcedSplashAbility(ability)
    @forcedSplashAbilityStack ||= []
    @forcedSplashAbilityStack.push(ability)
  end

  def popForcedSplashAbility
    return if !@forcedSplashAbilityStack || @forcedSplashAbilityStack.empty?
    @forcedSplashAbilityStack.pop
  end

  def hasAbilityOrInnate?(ability)
    ability_id = GameData::Ability.try_get(ability)&.id
    return false if !ability_id
    return true if self.ability_id == ability_id
    return true if self.abilityMutationList&.include?(ability_id)
    return false
  end

  def canReplaceAbility?(newAbility, targetAbility)
    return false if self.hasAbilityOrInnate?(newAbility)
    return false if self.hasActiveItem?(:ABILITYSHIELD)
    return false if ungainableAbility?(newAbility)
    return false if unstoppableAbility?(targetAbility)
    return true
  end
  
  #=============================================================================
  # Refreshing a battler's properties
  #=============================================================================
  alias abilityMutations_pbUpdate pbUpdate
  def pbUpdate(fullChange = false)
    return if !@pokemon
    abilityMutations_pbUpdate(fullChange)
    if !@effects[PBEffects::Transform] && fullChange
      if !@abilityMutationList.include?(@ability_id)
        if self.hasAbilityMutation?
          @abilityMutationList.unshift(@ability_id)
          @abilityMutationList=@abilityMutationList|[]
        else
          @abilityMutationList[0]=@ability_id
        end  
      end
    end
  end

  def hasActiveAbility?(check_ability, ignore_fainted = false)
    return false if !abilityActive?(ignore_fainted, check_ability)
    if self.hasAbilityMutation?
      if check_ability.is_a?(Array)
		    return (check_ability & @abilityMutationList).any?
      else
        return @abilityMutationList.include?(check_ability)	
      end 
    end	
    return check_ability.include?(@ability_id) if check_ability.is_a?(Array)
    return self.ability == check_ability
  end
  alias hasWorkingAbility hasActiveAbility? 

  def pbContinualAbilityChecks(onSwitchIn = false)
	  @battle.pbEndPrimordialWeather
	  # Handle Commander Ability
	  if hasActiveAbility?(:COMMANDER)
		  Battle::AbilityEffects.triggerOnSwitchIn(self.ability, self, @battle)
	  end
	  @proteanTrigger = false
	  plateType = pbGetJudgmentType(@legendPlateType)
	  @legendPlateType = plateType
	  # Handle Trace Ability
	  if hasActiveAbility?(:TRACE)
      if hasActiveItem?(:ABILITYSHIELD) # Trace failed by its own Ability Shield
        if onSwitchIn
			    @battle.pbShowAbilitySplash(self)
			    @battle.pbDisplay(_INTL("{1}'s Ability is protected by the effects of its Ability Shield!", pbThis))
			    @battle.pbHideAbilitySplash(self)
        end
      else
        choices = @battle.allOtherSideBattlers(@index).select do |b|
          next false if b.hasActiveItem?(:ABILITYSHIELD)
          next false if [:POWEROFALCHEMY, :RECEIVER, :TRACE].include?(b.ability_id)
          next false if b.uncopyableAbility?
          next false if self.abilityMutationList.include?(b.ability_id)
          true
        end
        if choices.length > 0
          choice = choices[@battle.pbRandom(choices.length)]
          copied_ability = choice.ability_id

          @battle.pbShowAbilitySplash(self, true, true, :TRACE)

          self.pbReplaceAbilitySlot(:TRACE, copied_ability)

          @battle.pbHideAbilitySplash(self)
          @battle.pbShowAbilitySplash(self, false, true, copied_ability)

          @battle.pbDisplay(_INTL("{1} traced {2}'s {3}!",
            pbThis, choice.pbThis(true), choice.abilityName))

          @battle.pbHideAbilitySplash(self)

          if !onSwitchIn && (unstoppableAbility? || abilityActive?)
            Battle::AbilityEffects.triggerOnSwitchIn(self.ability, self, @battle)
          end
        end
      end
	  end
	  pbMirrorStatUpsOpposing
  end

  alias aam_pbCanInflictStatus? pbCanInflictStatus?
  def pbCanInflictStatus?(newStatus, user, showMessages, move = nil, ignoreStatus = false)
    $aam_StatusImmunityFromAlly=[]
    aam_pbCanInflictStatus?(newStatus, user, showMessages, move, ignoreStatus)
  end
=begin
  def abilityName
    if @forcedSplashAbilityStack && !@forcedSplashAbilityStack.empty?
      return GameData::Ability.get(@forcedSplashAbilityStack.last).name
    end

    trig = currentTriggeredAbility
    return GameData::Ability.get(trig).name if trig

    if @lastBoostedAbility
      name = GameData::Ability.get(@lastBoostedAbility).name
      @lastBoostedAbility = nil   # auto-clear
      return name
    end

    abil = self.ability
    return abil ? abil.name : GameData::Ability.get(:NOABILITY).name
  end
=end
  def abilityName
    get_id = proc { |obj| obj.is_a?(MultiAbilityProxy) ? obj.primary : obj }

    if @forcedSplashAbilityStack && !@forcedSplashAbilityStack.empty?
      return GameData::Ability.get(get_id.call(@forcedSplashAbilityStack.last)).name
    end

    trig = currentTriggeredAbility
    return GameData::Ability.get(get_id.call(trig)).name if trig

    if @lastBoostedAbility
      name = GameData::Ability.get(get_id.call(@lastBoostedAbility)).name
      @lastBoostedAbility = nil
      return name
    end

    abil = self.ability
    return abil.respond_to?(:name) ? abil.name : GameData::Ability.get(:NOABILITY).name
  end


  #Ability switching codes ======================================================
  
  # Replace ONLY the primary ability with the new ability
  def pbReplacePrimaryAbility(new_ability)
    old_abil = self.abilityMutationList[0]
    self.abilityMutationList[0] = new_ability
    self.ability = new_ability
    return old_abil
  end

  # The caller and the target swap their primary ability
  def pbSwapPrimaryAbility(target)
    original = self.abilityMutationList[0]
    target_original = target.abilityMutationList[0]

    self.abilityMutationList[0] = target_original
    target.abilityMutationList[0] = original

    self.ability_id = self.abilityMutationList[0]
    target.ability_id = target.abilityMutationList[0]

    return original, target_original
  end

  # Replaces a specific ability in the mutation with the newly given ability
  def pbReplaceAbilitySlot(old_abil, new_abil)
    idx = @abilityMutationList.index(old_abil)
    return nil if !idx

    @lastBoostedAbility = old_abil
    @abilityMutationList[idx] = new_abil

    if idx == 0
      @ability_id = new_abil
    end

    return old_abil
  end
end

# Safari Zone Fix
class Battle::FakeBattler
  attr_accessor :abilityMutationList
  
  alias aam_initialize initialize
  def initialize(*args)
    aam_initialize(*args)
    @abilityMutationList=[]
  end

  def hasAbilityMutation?
    return (@pokemon) ? @pokemon.hasAbilityMutation? : false
  end
end

class Battle::Battler
  #-----------------------------------------------------------------------------
  # Aliased for Guard Dog, at long last.
  #-----------------------------------------------------------------------------
  alias innates_pbLowerStatStageByAbility pbLowerStatStageByAbility
  def pbLowerStatStageByAbility(stat, increment, user, splashAnim = true, checkContact = false)
    scary_abilities = [:INTIMIDATE, :TERRIFY, :ABSOLUTEDREAD]

    if hasActiveAbility?(:GUARDDOG) && scary_abilities.include?(user.currentTriggeredAbility)
      self.pushTriggeredAbility(:GUARDDOG)
      result = pbRaiseStatStageByAbility(stat, increment, self, true)
      self.popTriggeredAbility
      return result
    end

    return innates_pbLowerStatStageByAbility(stat, increment, user, splashAnim, checkContact)
  end
end