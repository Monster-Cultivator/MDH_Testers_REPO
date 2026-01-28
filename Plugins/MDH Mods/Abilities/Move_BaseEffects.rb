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