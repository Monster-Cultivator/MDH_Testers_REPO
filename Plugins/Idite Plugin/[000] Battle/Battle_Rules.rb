#===============================================================================
# Mind & Body Battle Rules
#===============================================================================
#-------------------------------------------------------------------------------
# Teach DBK's battle-rule parser that "limitedBag" expects a value.
#-------------------------------------------------------------------------------
alias limited_items_additionalRules additionalRules
def additionalRules
  rules = limited_items_additionalRules
  rules.push("limitedbag") if !rules.include?("limitedbag")
  return rules
end

#-------------------------------------------------------------------------------
# Store the rule in $game_temp.battle_rules.
#-------------------------------------------------------------------------------
class Game_Temp
  alias limited_items_add_battle_rule add_battle_rule
  def add_battle_rule(rule, var = nil)
    if rule.to_s.downcase == "limitedbag"
      self.battle_rules["limitedBag"] = [var.to_i, 0].max
      return
    end
    limited_items_add_battle_rule(rule, var)
  end
end

#-------------------------------------------------------------------------------
# Transfer the rule from battle prep into the Battle object.
#-------------------------------------------------------------------------------
module BattleCreationHelperMethods
  class << self
    alias limited_items_prepare_battle prepare_battle
    def prepare_battle(battle)
      limited_items_prepare_battle(battle)
      rules = $game_temp.battle_rules
      limit = rules["limitedBag"]
      battle.limitedBag = limit.nil? ? nil : [limit.to_i, 0].max
      battle.limitedBagUsed = 0
    end
  end
end

#-------------------------------------------------------------------------------
# Battle-side handling.
#-------------------------------------------------------------------------------
class Battle
  attr_accessor :limitedBag
  attr_accessor :limitedBagUsed

  # Prevent Bag after using all alotted items
  alias limited_items_pbItemMenu pbItemMenu
  def pbItemMenu(idxBattler, firstAction)
    if !@limitedBag.nil? && @limitedBagUsed.to_i >= @limitedBag
      pbDisplay(_INTL("You can't use any more items in this battle."))
      return false
    end
    return limited_items_pbItemMenu(idxBattler, firstAction)
  end

  #-----------------------------------------------------------------------------
  # Records one successful player item use.
  #
  # Essentials removes the item from the battler's choice slot when the item is
  # successfully used. If the item has no effect, it is returned to the Bag and
  # remains in the choice slot, so that failed attempt is not counted.
  #-----------------------------------------------------------------------------
  def pbLimitedBagRecordUse(item, userBattler, itemBeforeUse)
    return if @limitedBag.nil?
    return if !userBattler
    return if !pbOwnedByPlayer?(userBattler.index)
    return if itemBeforeUse != item
    return if @choices[userBattler.index][1] == item
    @limitedBagUsed = @limitedBagUsed.to_i + 1

    remaining = [@limitedBag - @limitedBagUsed, 0].max
    if remaining <= 0
      pbDisplay(_INTL("You have no item uses remaining in this battle."))
    elsif remaining == 1
      pbDisplay(_INTL("You have 1 item use remaining in this battle."))
    else
      pbDisplay(_INTL("You have {1} item uses remaining in this battle.", remaining))
    end
  end

  # Item used on a party Pokémon (Potion, Revive, Full Heal, Ether, etc.).
  alias limited_items_pbUseItemOnPokemon pbUseItemOnPokemon
  def pbUseItemOnPokemon(item, idxParty, userBattler)
    itemBeforeUse = @choices[userBattler.index][1]
    ret = limited_items_pbUseItemOnPokemon(item, idxParty, userBattler)
    pbLimitedBagRecordUse(item, userBattler, itemBeforeUse)
    return ret
  end

  # Item used on an active battler.
  alias limited_items_pbUseItemOnBattler pbUseItemOnBattler
  def pbUseItemOnBattler(item, idxParty, userBattler)
    itemBeforeUse = @choices[userBattler.index][1]
    ret = limited_items_pbUseItemOnBattler(item, idxParty, userBattler)
    pbLimitedBagRecordUse(item, userBattler, itemBeforeUse)
    return ret
  end

  # Poké Ball use.
  alias limited_items_pbUsePokeBallInBattle pbUsePokeBallInBattle
  def pbUsePokeBallInBattle(item, idxBattler, userBattler)
    itemBeforeUse = @choices[userBattler.index][1]
    ret = limited_items_pbUsePokeBallInBattle(item, idxBattler, userBattler)
    pbLimitedBagRecordUse(item, userBattler, itemBeforeUse)
    return ret
  end

  # Direct-use battle item (X items, Poké Doll-style items, etc.).
  alias limited_items_pbUseItemInBattle pbUseItemInBattle
  def pbUseItemInBattle(item, idxBattler, userBattler)
    itemBeforeUse = @choices[userBattler.index][1]
    ret = limited_items_pbUseItemInBattle(item, idxBattler, userBattler)
    pbLimitedBagRecordUse(item, userBattler, itemBeforeUse)
    return ret
  end
end
