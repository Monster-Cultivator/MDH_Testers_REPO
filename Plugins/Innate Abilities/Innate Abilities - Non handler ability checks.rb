#===============================================================================
# Sturdy's ability splash displayed properly
#===============================================================================
class Battle::Move 
  def pbEndureKOMessage(target)
    if target.damageState.disguise
      @battle.pbShowAbilitySplash(target)
      if Battle::Scene::USE_ABILITY_SPLASH
        @battle.pbDisplay(_INTL("Its disguise served it as a decoy!"))
      else
        @battle.pbDisplay(_INTL("{1}'s disguise served it as a decoy!", target.pbThis))
      end
      @battle.pbHideAbilitySplash(target)
      if target.hasSpecies?(:MIMIKYU)
        target.pbChangeForm(1, _INTL("{1}'s disguise was busted!", target.pbThis), :MIMIKYU)
      else
        @battle.pbDisplay(_INTL("{1}'s disguise was busted!",target.pbThis))
        target.disguiseFace = false
      end
      target.pbReduceHP(target.totalhp / 8, false) if Settings::MECHANICS_GENERATION >= 8
    elsif target.damageState.iceFace
      @battle.pbShowAbilitySplash(target)
      if !Battle::Scene::USE_ABILITY_SPLASH
        @battle.pbDisplay(_INTL("{1}'s {2} activated!", target.pbThis, target.abilityName))
      end
      if target.hasSpecies?(:EISCUE)
        target.pbChangeForm(1, _INTL("{1} transformed!", target.pbThis), :EISCUE)
      else
        target.disguiseFace = false
      end
      @battle.pbHideAbilitySplash(target)
    elsif target.damageState.endured
      @battle.pbDisplay(_INTL("{1} endured the hit!", target.pbThis))
    elsif target.damageState.sturdy
      @battle.pbShowAbilitySplash(target, false, true, :STURDY)
      if Battle::Scene::USE_ABILITY_SPLASH
        @battle.pbDisplay(_INTL("{1} endured the hit!", target.pbThis))
      else
        @battle.pbDisplay(_INTL("{1} hung on with Sturdy!", target.pbThis))
      end
      @battle.pbHideAbilitySplash(target)
    elsif target.damageState.focusSash
      @battle.pbCommonAnimation("UseItem", target)
      @battle.pbDisplay(_INTL("{1} hung on using its Focus Sash!", target.pbThis))
      target.pbConsumeItem
    elsif target.damageState.focusBand
      @battle.pbCommonAnimation("UseItem", target)
      @battle.pbDisplay(_INTL("{1} hung on using its Focus Band!", target.pbThis))
    elsif target.damageState.affection_endured
      @battle.pbDisplay(_INTL("{1} toughed it out so you wouldn't feel sad!", target.pbThis))
    end
  end
end

# Intercepts the game data to properly handle multiple abilities in the checks for ability.id or similar
module GameData
  class Ability
    class << self
      unless method_defined?(:innates_proxy_original_get)
        alias innates_proxy_original_get get
      end

      unless method_defined?(:innates_proxy_original_try_get)
        alias innates_proxy_original_try_get try_get
      end

      def get(id)
        id = id.primary if id.is_a?(MultiAbilityProxy)
        return innates_proxy_original_get(id)
      end

      def try_get(id)
        id = id.primary if id.is_a?(MultiAbilityProxy)
        return innates_proxy_original_try_get(id)
      end
    end
  end
end

# Proxy to handle multiple abilities
class MultiAbilityProxy
  attr_reader :battler, :primary

  def initialize(battler, primary_ability)
    @battler = battler
    @primary = primary_ability # The actual Symbol (e.g. :INTIMIDATE)
  end

  def id; @primary; end
  def to_sym; @primary; end
  def to_s; @primary.to_s; end
  def hash; @primary.hash; end
  def eql?(other); self == other; end

  def is_a?(klass)
    return true if klass == Symbol
    super
  end

  def ==(other)
    return false if other.nil?
    target_id = case other
                when Symbol then other
                when GameData::Ability then other.id
                when String then other.to_sym
                when MultiAbilityProxy then other.primary
                else return false
                end

    return true if @primary == target_id

    if @battler.instance_variable_defined?(:@abilityMutationList)
      list = @battler.instance_variable_get(:@abilityMutationList)
      return true if list&.include?(target_id)
    end

    if @battler.respond_to?(:active_innates)
      list = @battler.active_innates
      return true if list&.include?(target_id)
    end

    return false
  end

  # Forward name/description calls to the primary ability data
  def method_missing(m, *args, &block)
    data = GameData::Ability.try_get(@primary)
    if data && data.respond_to?(m)
      return data.send(m, *args, &block)
    end
    super
  end

  def respond_to_missing?(m, include_private = false)
    data = GameData::Ability.try_get(@primary)
    (data && data.respond_to?(m, include_private)) || super
  end
end

=begin
# OLD VERSION <3 Idite
class Battle::Battler
  alias __proxy_ability_id ability_id
  def ability_id
    res = __proxy_ability_id
    return nil if res.nil?
    return @__ability_proxy if @__ability_proxy&.primary == res
    #@__ability_proxy = MultiAbilityProxy.new(self, res)
    return @__ability_proxy = MultiAbilityProxy.new(self, res)
  end
  
  alias __proxy_ability ability
  def ability
    res = __proxy_ability
    return nil if res.nil?
    return @__ability_proxy if @__ability_proxy&.primary == res
    #return MultiAbilityProxy.new(self, res)
    return @__ability_proxy = MultiAbilityProxy.new(self, res)
  end
end
=end

# New, based version <3 idite
class Battle::Battler
  alias __proxy_ability_id ability_id
  def ability_id
    # During an ability splash, show the forced splash ability if one exists.
    if @forcedSplashAbilityStack && !@forcedSplashAbilityStack.empty?
      forced = @forcedSplashAbilityStack.last
      return nil if forced.nil?
      return @__forced_ability_proxy if @__forced_ability_proxy&.primary == forced
      return @__forced_ability_proxy = MultiAbilityProxy.new(self, forced)
    end

    res = __proxy_ability_id
    return nil if res.nil?
    return @__ability_proxy if @__ability_proxy&.primary == res
    return @__ability_proxy = MultiAbilityProxy.new(self, res)
  end

  alias __proxy_ability ability
  def ability
    # During an ability splash, show the forced splash ability if one exists.
    if @forcedSplashAbilityStack && !@forcedSplashAbilityStack.empty?
      forced = @forcedSplashAbilityStack.last
      return nil if forced.nil?
      return @__forced_ability_proxy if @__forced_ability_proxy&.primary == forced
      return @__forced_ability_proxy = MultiAbilityProxy.new(self, forced)
    end

    res = __proxy_ability
    return nil if res.nil?
    return @__ability_proxy if @__ability_proxy&.primary == res
    return @__ability_proxy = MultiAbilityProxy.new(self, res)
  end
end

#===============================================================================
# Do NOT proxy Pokemon#ability_id.
# Breaks the shit out of Overworld Abilities
#===============================================================================
class Pokemon
  def innate_aware_ability_ids
    ret = []
    ret.push(self.ability_id) if self.ability_id

    if self.respond_to?(:unlocked_innates)
      ret.concat(self.unlocked_innates || [])
    elsif self.respond_to?(:active_innates)
      ret.concat(self.active_innates || [])
    end

    ret.compact.uniq
  end

  def abilityAble?(ability)
    return false if !ability
    return true if self.hasAbility?(ability)
    return innate_aware_ability_ids.include?(ability)
  end
end

# For Wild Encounters
class PokemonEncounters
  def lead_has_encounter_ability?(pkmn, ability)
    return false if !pkmn
    return true if pkmn.ability_id == ability
    return true if pkmn.respond_to?(:abilityAble?) && pkmn.abilityAble?(ability)
    return false
  end
end