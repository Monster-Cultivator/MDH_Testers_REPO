MultipleForms.register(:PENNY, {
  "getFormOnLeavingBattle" => proc { |pkmn, battle, usedInBattle, endBattle|
    next 0 if pkmn.fainted? || endBattle
  }
})

MultipleForms.register(:PENNY_2, {
  "getFormOnLeavingBattle" => proc { |pkmn, battle, usedInBattle, endBattle|
    next 0 if pkmn.fainted? || endBattle
  }
})

class Battle::Move
  def pbCheckDamageAbsorption(user, target)
    # Substitute will take the damage
    if target.effects[PBEffects::Substitute] > 0 && !ignoresSubstitute?(user) &&
       (!user || user.index != target.index)
      target.damageState.substitute = true
      return
    end
    # Ice Face will take the damage
    if !@battle.moldBreaker && target.isSpecies?(:EISCUE) &&
       target.form == 0 && target.ability == :ICEFACE && physicalMove?
      target.damageState.iceFace = true
      return
    end
    # Disguise
    if !@battle.moldBreaker && (target.isSpecies?(:MIMIKYU) || target.isSpecies?(:PENNY) || target.isSpecies?(:PENNY_2)) &&
      target.form == 0 && target.ability == :DISGUISE
      target.damageState.disguise = true
    end
  end
end 