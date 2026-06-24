# Mummy (and Lingering Aroma) replace the Pokémon's ability in the mutation list,
# while keeping the innates as they are.
Battle::AbilityEffects::OnBeingHit.add(:MUMMY,
  proc { |ability, user, target, move, battle|
    next if !move.pbContactMove?(user)
    next if user.fainted?
    next if user.unstoppableAbility?
    next if user.abilityMutationList.include?(:MUMMY)
    next if user.abilityMutationList.include?(:LINGERINGAROMA)
    next if user.hasActiveItem?(:ABILITYSHIELD)

    battle.pbShowAbilitySplash(target) if user.opposes?(target)
    oldAbil = nil
    if user.affectedByContactEffect?(Battle::Scene::USE_ABILITY_SPLASH)
      battle.pbShowAbilitySplash(user, true, false) if user.opposes?(target)
      
      oldAbil = user.pbReplacePrimaryAbility(ability)

      battle.pbReplaceAbilitySplash(user) if user.opposes?(target)
      if Battle::Scene::USE_ABILITY_SPLASH
        case ability
        when :MUMMY
          msg = _INTL("{1}'s Ability became {2}!", user.pbThis, user.abilityName)
        when :LINGERINGAROMA
          msg = _INTL("A lingering aroma clings to {1}!", user.pbThis(true))
        else
          msg = _INTL("{1}'s Ability became {2}!", user.pbThis, user.abilityName)
        end
        battle.pbDisplay(msg)
      else
        battle.pbDisplay(_INTL("{1}'s Ability became {2} because of {3}!",
           user.pbThis, user.abilityName, target.pbThis(true)))
      end
      battle.pbHideAbilitySplash(user) if user.opposes?(target)
    end

    battle.pbHideAbilitySplash(target) if user.opposes?(target)

    if oldAbil
      user.pbOnLosingAbility(oldAbil)
      user.pbTriggerAbilityOnGainingIt
    end
  }
)
Battle::AbilityEffects::OnBeingHit.copy(:MUMMY, :LINGERINGAROMA)

# Wandering Spirit swaps the Pokémon's ability with the attacker's main ability, but only if the Wandering Spirit Pokémon doesn't already have the attacker's main ability.
Battle::AbilityEffects::OnBeingHitSpirit.add(:WANDERINGSPIRIT,
  proc { |ability, user, target, move, battle|
    next if !move.pbContactMove?(user)
    next if PluginManager.installed?("Deluxe Battle Kit") && user.dynamax?
    next if user.ungainableAbility? || [:RECEIVER, :WONDERGUARD, :POWEROFALCHEMY].include?(user.ability_id)
    next if user.hasActiveItem?(:ABILITYSHIELD) || target.hasActiveItem?(:ABILITYSHIELD)

    ws_index = target.abilityMutationList.index(:WANDERINGSPIRIT)
    next if ws_index.nil?

    next if user.abilityMutationList.include?(:WANDERINGSPIRIT)
    next if target.abilityMutationList.include?(user.ability)

    battle.pbShowAbilitySplash(target) if user.opposes?(target)

    if user.affectedByContactEffect?(Battle::Scene::USE_ABILITY_SPLASH)
      battle.pbShowAbilitySplash(user, true, false) if user.opposes?(target)

      oldUserAbil   = user.abilityMutationList[0]
      oldTargetAbil = target.abilityMutationList[ws_index] # This is :WANDERINGSPIRIT

      user.abilityMutationList[0]          = oldTargetAbil
      target.abilityMutationList[ws_index] = oldUserAbil

      user.ability_id   = user.abilityMutationList[0]
      target.ability_id = target.abilityMutationList[0]

      if user.opposes?(target)
        battle.pbReplaceAbilitySplash(user)
        battle.pbShowAbilitySplash(target, false, false, oldUserAbil)
      end

      battle.pbDisplay(_INTL("{1} swapped Abilities with {2}!", target.pbThis, user.pbThis(true)))

      if user.opposes?(target)
        battle.pbHideAbilitySplash(user)
        battle.pbHideAbilitySplash(target)
      end

      user.pbOnLosingAbility(oldUserAbil)
      target.pbOnLosingAbility(oldTargetAbil)
      user.pbTriggerAbilityOnGainingIt
      target.pbTriggerAbilityOnGainingIt
    end

    battle.pbHideAbilitySplash(target) if user.opposes?(target)
  }
)

Battle::AbilityEffects::ChangeOnBattlerFainting.add(:POWEROFALCHEMY,
  proc { |ability, battler, fainted, battle|
    next if battler.opposes?(fainted)
    next if fainted.ungainableAbility? ||
            [:POWEROFALCHEMY, :RECEIVER, :TRACE, :WONDERGUARD].include?(fainted.ability_id)

    next if battler.abilityMutationList.include?(fainted.ability_id)

    index = battler.abilityMutationList.index(:POWEROFALCHEMY) || 
            battler.abilityMutationList.index(:RECEIVER)
    next if index.nil?

    battle.pbShowAbilitySplash(battler, true)

    oldAbil = battler.abilityMutationList[index]
    newAbil = fainted.ability_id
    battler.abilityMutationList[index] = newAbil

    battler.ability_id = battler.abilityMutationList[0]

    battle.pbShowAbilitySplash(battler, false, false, newAbil)
    battle.pbDisplay(_INTL("{1} acquired {2}'s {3}!", 
      battler.pbThis, fainted.pbThis(true), GameData::Ability.get(newAbil).name))
    battle.pbHideAbilitySplash(battler)

    battler.pbOnLosingAbility(oldAbil)
    battler.pbTriggerAbilityOnGainingIt
  }
)

Battle::AbilityEffects::ChangeOnBattlerFainting.copy(:POWEROFALCHEMY, :RECEIVER)

# ===========================================================================================================
# Simple Beam replaces the primary ability with Simple, but only if the target doesn't already have Simple in their mutation list.
# Or to get rid of Truant for some reason.
# ===========================================================================================================
class Battle::Move::SetTargetAbilityToSimple < Battle::Move
  def canMagicCoat?; return true; end

  def pbMoveFailed?(user, targets)
    if !GameData::Ability.exists?(:SIMPLE)
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbFailsAgainstTarget?(user, target, show_message)
    if target.unstoppableAbility? || target.abilityMutationList.include?(:SIMPLE) || target.ability_id == :TRUANT || target.hasActiveItem?(:ABILITYSHIELD)
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user, target)
    @battle.pbShowAbilitySplash(target, true, false)
    oldAbil = target.pbReplacePrimaryAbility(:SIMPLE)
    @battle.pbReplaceAbilitySplash(target)
    @battle.pbDisplay(_INTL("{1} acquired {2}!", target.pbThis, target.abilityName))
    @battle.pbHideAbilitySplash(target)
    target.pbOnLosingAbility(oldAbil)
    target.pbTriggerAbilityOnGainingIt
  end
end

# ===========================================================================================================
# Worry Seed replaces the primary ability with Insomnia, but only if the target doesn't already have Insomnia in their mutation list.
# Or to get rid of Truant for some reason...
# ===========================================================================================================
class Battle::Move::SetTargetAbilityToInsomnia < Battle::Move
  def canMagicCoat?; return true; end

  def pbMoveFailed?(user, targets)
    if !GameData::Ability.exists?(:INSOMNIA)
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbFailsAgainstTarget?(user, target, show_message)
    if target.unstoppableAbility? || target.abilityMutationList.include?(:INSOMNIA) || target.ability_id == :TRUANT || target.hasActiveItem?(:ABILITYSHIELD)
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user, target)
    @battle.pbShowAbilitySplash(target, true, false)
    oldAbil = target.pbReplacePrimaryAbility(:INSOMNIA)
    @battle.pbReplaceAbilitySplash(target)
    @battle.pbDisplay(_INTL("{1} acquired {2}!", target.pbThis, target.abilityName))
    @battle.pbHideAbilitySplash(target)
    target.pbOnLosingAbility(oldAbil)
    target.pbTriggerAbilityOnGainingIt
  end
end

# ===========================================================================================================
# Role Play replaces the primary ability with the target's primary ability, but only if the user doesn't already have that ability in their mutation list.
# ===========================================================================================================
class Battle::Move::SetUserAbilityToTargetAbility < Battle::Move
  def ignoresSubstitute?(user); return true; end

  def pbMoveFailed?(user, targets)
    if user.unstoppableAbility?
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbFailsAgainstTarget?(user, target, show_message)
    if !target.ability || user.ability == target.ability
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    if target.ungainableAbility? ||
       [:POWEROFALCHEMY, :RECEIVER, :TRACE, :WONDERGUARD].include?(target.ability_id)
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    if user.abilityMutationList.include?(target.ability_id)
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user, target)
    @battle.pbShowAbilitySplash(user, true, false)
    oldAbil = user.pbReplacePrimaryAbility(target.ability_id)
    @battle.pbReplaceAbilitySplash(user)
    @battle.pbDisplay(_INTL("{1} copied {2}'s {3}!",
                            user.pbThis, target.pbThis(true), target.abilityName))
    @battle.pbHideAbilitySplash(user)
    user.pbOnLosingAbility(oldAbil)
    user.pbTriggerAbilityOnGainingIt
  end
end

#===============================================================================
# Entrainment replaces the target's ability with the user's primary ability, but only if the target doesn't already have that ability in their mutation list.
#===============================================================================
class Battle::Move::SetTargetAbilityToUserAbility < Battle::Move
  def canMagicCoat?; return true; end

  def pbMoveFailed?(user, targets)
    if !user.ability
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if user.ungainableAbility? ||
       [:POWEROFALCHEMY, :RECEIVER, :TRACE].include?(user.ability_id)
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbFailsAgainstTarget?(user, target, show_message)
    if target.unstoppableAbility? || target.ability == :TRUANT || target.hasActiveItem?(:ABILITYSHIELD)
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    if target.abilityMutationList.include?(user.ability_id) || target.hasActiveItem?(:ABILITYSHIELD)
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user, target)
    @battle.pbShowAbilitySplash(target, true, false)
    oldAbil = target.pbReplacePrimaryAbility(user.ability_id)
    @battle.pbReplaceAbilitySplash(target)
    @battle.pbDisplay(_INTL("{1} acquired {2}!", target.pbThis, target.abilityName))
    @battle.pbHideAbilitySplash(target)
    target.pbOnLosingAbility(oldAbil)
    target.pbTriggerAbilityOnGainingIt
  end
end

#===============================================================================
# User and target swap primary abilities. (Skill Swap)
#===============================================================================
class Battle::Move::UserTargetSwapAbilities < Battle::Move
  def ignoresSubstitute?(user); return true; end

  def pbMoveFailed?(user, targets)
    if !user.ability
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if user.unstoppableAbility?
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if user.ungainableAbility? || user.ability == :WONDERGUARD
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbFailsAgainstTarget?(user, target, show_message)
    if !target.ability ||
       (user.ability == target.ability && Settings::MECHANICS_GENERATION <= 5)
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    if target.unstoppableAbility? || target.hasActiveItem?(:ABILITYSHIELD)
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    if target.ungainableAbility? || target.ability == :WONDERGUARD
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    if user.abilityMutationList.include?(target.ability) || 
       target.abilityMutationList.include?(user.ability)
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user, target)
    oldUserAbil   = user.ability
    oldTargetAbil = target.ability

    if user.opposes?(target)
      @battle.pbShowAbilitySplash(user, false, false, oldUserAbil)
      @battle.pbShowAbilitySplash(target, true, false, oldTargetAbil)
    end

    user.pbSwapPrimaryAbility(target)

    if user.opposes?(target)
      @battle.pbShowAbilitySplash(user, false, false, user.ability)
      @battle.pbShowAbilitySplash(target, true, false, target.ability)
    end

    if Battle::Scene::USE_ABILITY_SPLASH
      @battle.pbDisplay(_INTL("{1} swapped Abilities with its target!", user.pbThis))
    else
      @battle.pbDisplay(_INTL("{1} swapped its {2} Ability with its target's {3} Ability!",
                              user.pbThis, oldTargetAbil.name, oldUserAbil.name))
    end

    if user.opposes?(target)
      @battle.pbHideAbilitySplash(user)
      @battle.pbHideAbilitySplash(target)
    end

    user.pbOnLosingAbility(oldUserAbil)
    target.pbOnLosingAbility(oldTargetAbil)
    user.pbTriggerAbilityOnGainingIt
    target.pbTriggerAbilityOnGainingIt
  end
end

#===============================================================================
# Doodle makes the user and it's allies gain the switch ability of the target
# Works if at least one of them can gain the ability
#===============================================================================
class Battle::Move::SetUserAlliesAbilityToTargetAbility < Battle::Move
  def ignoresSubstitute?(user); return true; end
  
  def pbMoveFailed?(user, targets)
    @battle.allSameSideBattlers(user.index).each do |b|
      next if !b.unstoppableAbility?
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if user.hasActiveItem?(:ABILITYSHIELD)
      @battle.pbDisplay(_INTL("{1}'s Ability is protected by the effects of its Ability Shield!",user.pbThis))
      return true
    end
    return false
  end

  def pbFailsAgainstTarget?(user, target, show_message)
    if !target.ability || target.uncopyableAbility?
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    target_abil = target.ability
    can_copy_any = false
    @battle.allSameSideBattlers(user.index).each do |b|
      next if b.unstoppableAbility?
      # Skip if they already have this ability anywhere in their mutation/innate list
      next if b.abilityMutationList.include?(target_abil)
      can_copy_any = true
      break
    end

    if !can_copy_any
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    return false
  end
  
  def pbEffectAgainstTarget(user, target)
    target_abil = target.ability
    @battle.allSameSideBattlers(user).each do |b|
	    next if b.abilityMutationList.include?(target_abil)
      next if b.unstoppableAbility?
      if b.hasActiveItem?(:ABILITYSHIELD)
        @battle.pbDisplay(_INTL("{1}'s Ability is protected by the effects of its Ability Shield!", b.pbThis))
      else
        @battle.pbShowAbilitySplash(b, true, false, b.ability)
        oldAbil = b.pbReplacePrimaryAbility(target_abil)
        @battle.pbShowAbilitySplash(b, false, false, b.ability)
        @battle.pbDisplay(_INTL("{1} copied {2}'s {3}!",
                            user.pbThis, target.pbThis(true), target.abilityName))
        @battle.pbHideAbilitySplash(b)
        b.pbOnLosingAbility(oldAbil)
        b.pbTriggerAbilityOnGainingIt
      end
    end
  end
end