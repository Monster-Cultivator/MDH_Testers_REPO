#===============================================================================
# Two turn move.
#===============================================================================
class Battle::Move::TwoTurnMove < Battle::Move
    attr_reader :chargingTurn
  
    def chargingTurnMove?; return true; end
  
    # user.effects[PBEffects::TwoTurnAttack] is set to the move's ID if this
    # method returns true, or nil if false.
    # Non-nil means the charging turn. nil means the attacking turn.
    def pbIsChargingTurn?(user)
        @powerHerb = false
        @chargingTurn = false   # Assume damaging turn by default
        @damagingTurn = true
      
        # Time Warp Ability - Skip charging turn if user or allies have Time Warp
        if user.hasActiveAbility?(:TIMEWARP) || user.allAllies.any? { |ally| ally.hasActiveAbility?(:TIMEWARP) }
          @chargingTurn = true   # Still register the charging turn for animation
          @damagingTurn = true   # Proceed directly to damaging turn after animation
          return false           # Skip the charging turn logic, but allow the animation to play
        end
           
        # Regular logic for Power Herb or normal charging
        if !user.effects[PBEffects::TwoTurnAttack]
          @powerHerb = user.hasActiveItem?(:POWERHERB)
          @chargingTurn = true
          @damagingTurn = @powerHerb
        end
        return !@damagingTurn   # Deliberately not "return @chargingTurn"
      end

    # Stops damage being dealt in the first (charging) turn.
    def pbDamagingMove?
      return false if !@damagingTurn
      return super
    end
  
    # Does the charging part of this move, for when this move only takes one round
    # to use.
    def pbQuickChargingMove(user, targets)
      return if !@chargingTurn || !@damagingTurn   # Move only takes one turn to use
      pbChargingTurnMessage(user, targets)
      pbShowAnimation(@id, user, targets, 1)   # Charging anim
      
      # Show Time Warp ability splash if the user or its allies have it
        if user.hasActiveAbility?(:TIMEWARP) || user.allAllies.any? { |ally| ally.hasActiveAbility?(:TIMEWARP) }
             @battle.pbShowAbilitySplash(user)
             @battle.pbDisplay(_INTL("{1}'s {2} allows it to skip charging!", user.pbThis, user.abilityName))
             @battle.pbHideAbilitySplash(user)
          end
      targets.each { |b| pbChargingTurnEffect(user, b) }
      if @powerHerb
        # Moves that would make the user semi-invulnerable will hide the user
        # after the charging animation, so the "UseItem" animation shouldn't show
        # for it
        if !["TwoTurnAttackInvulnerableInSky",
             "TwoTurnAttackInvulnerableUnderground",
             "TwoTurnAttackInvulnerableUnderwater",
             "TwoTurnAttackInvulnerableInSkyParalyzeTarget",
             "TwoTurnAttackInvulnerableRemoveProtections",
             "TwoTurnAttackInvulnerableInSkyTargetCannotAct"].include?(@function_code)
          @battle.pbCommonAnimation("UseItem", user)
        end
        @battle.pbDisplay(_INTL("{1} became fully charged due to its Power Herb!", user.pbThis))
        user.pbConsumeItem
      end
    end
  
    def pbAccuracyCheck(user, target)
      return true if !@damagingTurn
      return super
    end
  
    def pbInitialEffect(user, targets, hitNum)
      if @damagingTurn
        pbAttackingTurnMessage(user, targets)
      elsif @chargingTurn
        pbChargingTurnMessage(user, targets)
      end
    end
  
    def pbChargingTurnMessage(user, targets)
      @battle.pbDisplay(_INTL("{1} began charging up!", user.pbThis))
    end
  
    def pbAttackingTurnMessage(user, targets); end
  
    def pbEffectAgainstTarget(user, target)
      if @damagingTurn
        pbAttackingTurnEffect(user, target)
      elsif @chargingTurn
        pbChargingTurnEffect(user, target)
      end
    end
  
    def pbChargingTurnEffect(user, target)
      # Skull Bash/Sky Drop are the only two-turn moves with an effect here, and
      # the latter just records the target is being Sky Dropped
    end
  
    def pbAttackingTurnEffect(user, target); end
  
    def pbShowAnimation(id, user, targets, hitNum = 0, showAnimation = true)
      hitNum = 1 if @chargingTurn && !@damagingTurn   # Charging anim
      super
    end
  end
  
 class Battle::Move::ChangeUserHattereneForm < Battle::Move
  def pbEndOfMoveUsageEffect(user, targets, numHits, switchedBattlers)
    return if numHits == 0
    return if user.fainted? || user.effects[PBEffects::Transform]
    return if !user.isSpecies?(:HATTERENE_2)
    return if user.hasActiveAbility?(:SHEERFORCE) && @addlEffect > 0
    newForm = (user.form + 1) % 2
    user.pbChangeForm(newForm, _INTL("{1} transformed!", user.pbThis))
  end
end
