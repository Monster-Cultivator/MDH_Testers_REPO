Battle::ItemEffects::EndOfRoundHealing.add(:EXLEFTOVERS,
  proc { |item, battler, battle|
    next if !battler.canHeal?
    battle.pbCommonAnimation("UseItem", battler)
    battler.pbRecoverHP(battler.totalhp / 8)
    battle.pbDisplay(_INTL("{1} restored a little HP using its {2}!",
       battler.pbThis, battler.itemName))
  }
)

Battle::ItemEffects::OnBeingHit.add(:EXWEAKNESSPOLICY,
  proc { |item, user, target, move, battle|
    next if target.damageState.disguise || target.damageState.iceFace
    next if !Effectiveness.super_effective?(target.damageState.typeMod)
    next if !target.pbCanRaiseStatStage?(:ATTACK, target) &&
            !target.pbCanRaiseStatStage?(:SPECIAL_ATTACK, target)
    battle.pbCommonAnimation("UseItem", target)
    showAnim = true
    if target.pbCanRaiseStatStage?(:ATTACK, target)
      target.pbRaiseStatStageByCause(:ATTACK, 3, target, target.itemName, showAnim)
      showAnim = false
    end
    if target.pbCanRaiseStatStage?(:SPECIAL_ATTACK, target)
      target.pbRaiseStatStageByCause(:SPECIAL_ATTACK, 3, target, target.itemName, showAnim)
    end
    battle.pbDisplay(_INTL("The {1} was used up...", target.itemName))
    target.pbHeldItemTriggered(item)
  }
)

