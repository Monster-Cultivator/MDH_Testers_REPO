def pbEORHealingEffects(priority)
  # Leech Seed
  priority.each do |battler|
    next if battler.effects[PBEffects::LeechSeedEX] < 0
    next if !battler.takesIndirectDamage?
    recipient = @battlers[battler.effects[PBEffects::LeechSeedEX]]
    next if !recipient || recipient.fainted?

    pbCommonAnimation("LeechSeed", recipient, battler)

    battler.pbTakeEffectDamage(battler.totalhp / 6) do |hp_lost|
      recipient.pbRecoverHPFromDrain(
        hp_lost, battler,
        _INTL("{1}'s health is sapped by Leech Seed!", battler.pbThis)
      )
      recipient.pbAbilitiesOnDamageTaken

      [:ATTACK, :SPECIAL_ATTACK, :SPEED].each do |stat|
        next if !battler.pbCanLowerStatStage?(stat, recipient)
        battler.pbLowerStatStage(stat, 1, recipient)
      end
    end

    battler.pbFaint if battler.fainted?
  end
end