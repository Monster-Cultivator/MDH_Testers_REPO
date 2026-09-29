#===============================================================================
# Challenge Clauses
#-------------------------------------------------------------------------------
# Adds per-battle competitive clauses intended for difficult trainer battles.
#
# USAGE:
#   pbSetChallengeClauses(
#     :restricted => 1,
#     :species    => true,
#     :item       => true,
#     :sleep      => true
#   )
#   TrainerBattle.start(:TRAINERTYPE, "Name", 0)
#
#===============================================================================

module ChallengeClauses
  #=============================================================================
  # CONFIGURATION
  #=============================================================================
  # Put every species that should count toward the Restricted Species Clause in
  # this list. Forms use their base species ID in Essentials, so :GIRATINA, for
  # example, covers its forms as well.
  #
  # Example:
  #   RESTRICTED_SPECIES = [
  #     :MEWTWO,
  #     :LUGIA,
  #     :HOOH,
  #     :RAYQUAZA
  #   ]
  #
  RESTRICTED_SPECIES = [
    # :MEWTWO,
    # :LUGIA,
    # :HOOH,
    # :RAYQUAZA,
  ]

  DEFAULT_SLEEP_CLAUSE_SCOPE = :BOTH

  RULE_KEY = "challengeClauses"

  #=============================================================================
  # NEXT-BATTLE RULE MANAGEMENT
  #=============================================================================

  def self.normalize_options(options)
    options ||= {}
    restricted = options[:restricted]
    restricted = options[:restricted_limit] if restricted.nil?
    species_clause = options.key?(:species) ? options[:species] : options[:species_clause]
    item_clause = options.key?(:item) ? options[:item] : options[:item_clause]
    sleep_clause = options.key?(:sleep) ? options[:sleep] : options[:sleep_clause]
    sleep_scope = options[:sleep_scope] || DEFAULT_SLEEP_CLAUSE_SCOPE
    sleep_scope = sleep_scope.to_s.upcase.to_sym
    sleep_scope = DEFAULT_SLEEP_CLAUSE_SCOPE if ![:PLAYER_ONLY, :BOTH].include?(sleep_scope)

    if !restricted.nil?
      restricted = restricted.to_i
      restricted = 0 if restricted < 0
    end

    return {
      :restricted_limit => restricted,
      :species_clause   => !!species_clause,
      :item_clause      => !!item_clause,
      :sleep_clause     => !!sleep_clause,
      :sleep_scope      => sleep_scope
    }
  end

  def self.set_for_next_battle(options = {})
    $game_temp.battle_rules[RULE_KEY] = normalize_options(options)
  end

  def self.current_pending_rules
    return nil if !$game_temp
    return $game_temp.battle_rules[RULE_KEY]
  end

  def self.battle_rules(battle)
    return nil if !battle || !battle.respond_to?(:rules)
    return battle.rules[RULE_KEY]
  end

  def self.active?(battle, clause)
    rules = battle_rules(battle)
    return false if !rules
    return !!rules[clause]
  end

  #=============================================================================
  # PARTY VALIDATION
  #=============================================================================

  def self.restricted_species?(pkmn)
    return false if !pkmn
    return RESTRICTED_SPECIES.include?(pkmn.species)
  end

  def self.species_name(pkmn)
    return "Pokémon" if !pkmn
    data = GameData::Species.try_get(pkmn.species)
    return data.name if data
    return pkmn.name
  end

  def self.item_name(item_id)
    data = GameData::Item.try_get(item_id)
    return data.name if data
    return item_id.to_s
  end

  def self.validate_restricted_species(party, limit)
    return true if limit.nil?
    restricted = party.select { |pkmn| restricted_species?(pkmn) }
    return true if restricted.length <= limit

    names = restricted.map { |pkmn| species_name(pkmn) }
    pbMessage(_INTL(
      "This battle allows only {1} restricted Pokémon. Your party has {2}: {3}.",
      limit, restricted.length, names.join(", ")
    ))
    return false
  end

  def self.validate_species_clause(party)
    seen = {}
    party.each do |pkmn|
      next if !pkmn
      species = pkmn.species
      if seen[species]
        first = seen[species]
        pbMessage(_INTL(
          "Species Clause is active, which means \\byou cannot use multiple Pokémon of the same species in this battle! \\r{1} \\c[0]and \\r{2} \\c[0]are both \\r{3}\\c[0]. Please utilize the PC Storage Link available in the Pokégear, or backtrack to a Pokémon Center.",
          first.name, pkmn.name, species_name(pkmn)
        ))
        return false
      end
      seen[species] = pkmn
    end
    return true
  end

  def self.validate_item_clause(party)
    seen = {}
    party.each do |pkmn|
      next if !pkmn
      item = pkmn.item_id
      next if item.nil? || item == :NONE
      if seen[item]
        first = seen[item]
        pbMessage(_INTL(
          "Item Clause is active. {1} and {2} are both holding {3}.",
          first.name, pkmn.name, item_name(item)
        ))
        return false
      end
      seen[item] = pkmn
    end
    return true
  end

  def self.validate_player_party
    rules = current_pending_rules
    return true if !rules
    party = $player.party

    return false if !validate_restricted_species(party, rules[:restricted_limit])
    return false if rules[:species_clause] && !validate_species_clause(party)
    return false if rules[:item_clause] && !validate_item_clause(party)
    return true
  end

  #=============================================================================
  # SLEEP CLAUSE HELPERS
  #=============================================================================

  def self.sleep_clause_active?(battle)
    return active?(battle, :sleep_clause)
  end

  def self.side_party(battle, side_index)
    return battle.pbParty(side_index)
  rescue
    return []
  end

  def self.sleeping_pokemon_on_side(battle, side_index)
    return side_party(battle, side_index).select do |pkmn|
      next false if !pkmn || pkmn.fainted?
      next false if pkmn.status != :SLEEP
      true
    end
  end

  def self.side_has_sleeping_pokemon?(battle, side_index)
    return !sleeping_pokemon_on_side(battle, side_index).empty?
  end

  def self.battlers_opposing?(user, target)
    return false if !user || !target
    begin
      return target.opposes?(user)
    rescue
      return (user.index & 1) != (target.index & 1)
    end
  end

  def self.source_is_restricted_by_sleep_clause?(battle, source_index)
    return false if source_index.nil? || source_index < 0
    rules = battle_rules(battle)
    scope = (rules && rules[:sleep_scope]) || DEFAULT_SLEEP_CLAUSE_SCOPE
    case scope
    when :PLAYER_ONLY
      begin
        return battle.pbOwnedByPlayer?(source_index)
      rescue
        return (source_index & 1) == 0
      end
    else   # :BOTH
      return true
    end
  end

  def self.sleep_blocked_for?(battle, user, target)
    return false if !sleep_clause_active?(battle)
    return false if !user || !target
    return false if user.index == target.index   # Rest/self-sleep is always usable
    return false if !battlers_opposing?(user, target)
    return false if !source_is_restricted_by_sleep_clause?(battle, user.index)
    return side_has_sleeping_pokemon?(battle, target.index & 1)
  end

  # Guaranteed sleep *status* moves are blocked at command selection while a
  # Pokémon on the target side is already asleep. Damaging moves with a sleep
  # secondary effect are intentionally NOT blocked here.
  def self.guaranteed_sleep_move?(move)
    return false if !move || !move.statusMove?
    code = move.function_code.to_s
    return code.include?("SleepTarget")
  end

  def self.guaranteed_sleep_move_blocked?(battle, user, move)
    return false if !sleep_clause_active?(battle)
    return false if !guaranteed_sleep_move?(move)
    return false if !source_is_restricted_by_sleep_clause?(battle, user.index)
    opposing_side = 1 - (user.index & 1)
    return side_has_sleeping_pokemon?(battle, opposing_side)
  end
end

#===============================================================================
# EVENT SCRIPT API
#===============================================================================

# Main helper. Put this immediately before TrainerBattle.start(...).
#
# Example:
#   pbSetChallengeClauses(:restricted => 1, :item => true, :sleep => true)
#
def pbSetChallengeClauses(options = {})
  ChallengeClauses.set_for_next_battle(options)
end

# Convenience helpers if you prefer setting one rule at a time.
def pbSetRestrictedSpeciesLimit(limit)
  rules = ChallengeClauses.current_pending_rules || {
    :restricted_limit => nil,
    :species_clause   => false,
    :item_clause      => false,
    :sleep_clause     => false,
    :sleep_scope      => ChallengeClauses::DEFAULT_SLEEP_CLAUSE_SCOPE
  }
  rules = rules.clone
  rules[:restricted_limit] = [limit.to_i, 0].max
  $game_temp.battle_rules[ChallengeClauses::RULE_KEY] = rules
end

def pbEnableSpeciesClause(value = true)
  rules = ChallengeClauses.current_pending_rules || {
    :restricted_limit => nil,
    :species_clause   => false,
    :item_clause      => false,
    :sleep_clause     => false,
    :sleep_scope      => ChallengeClauses::DEFAULT_SLEEP_CLAUSE_SCOPE
  }
  rules = rules.clone
  rules[:species_clause] = !!value
  $game_temp.battle_rules[ChallengeClauses::RULE_KEY] = rules
end

def pbEnableItemClause(value = true)
  rules = ChallengeClauses.current_pending_rules || {
    :restricted_limit => nil,
    :species_clause   => false,
    :item_clause      => false,
    :sleep_clause     => false,
    :sleep_scope      => ChallengeClauses::DEFAULT_SLEEP_CLAUSE_SCOPE
  }
  rules = rules.clone
  rules[:item_clause] = !!value
  $game_temp.battle_rules[ChallengeClauses::RULE_KEY] = rules
end

def pbEnableSleepClause(value = true, scope = nil)
  rules = ChallengeClauses.current_pending_rules || {
    :restricted_limit => nil,
    :species_clause   => false,
    :item_clause      => false,
    :sleep_clause     => false,
    :sleep_scope      => ChallengeClauses::DEFAULT_SLEEP_CLAUSE_SCOPE
  }
  rules = rules.clone
  rules[:sleep_clause] = !!value
  if scope
    scope = scope.to_s.upcase.to_sym
    rules[:sleep_scope] = scope if [:PLAYER_ONLY, :BOTH].include?(scope)
  end
  $game_temp.battle_rules[ChallengeClauses::RULE_KEY] = rules
end

def pbClearChallengeClauses
  return if !$game_temp
  $game_temp.battle_rules.delete(ChallengeClauses::RULE_KEY)
end

#===============================================================================
# Copy the temporary rule configuration into the Battle object before
# Essentials clears $game_temp.battle_rules.
#===============================================================================
module ChallengeClauses_PrepareBattle
  def prepare_battle(battle)
    super
    rules = ChallengeClauses.current_pending_rules
    battle.rules[ChallengeClauses::RULE_KEY] = rules.clone if rules
  end
end
BattleCreationHelperMethods.singleton_class.prepend(ChallengeClauses_PrepareBattle)

#===============================================================================
# Reject an illegal party before a trainer battle begins.
#===============================================================================
module ChallengeClauses_TrainerBattleStart
  def start_core(*args)
    if ChallengeClauses.current_pending_rules && !ChallengeClauses.validate_player_party
      outcome_variable = $game_temp.battle_rules["outcomeVar"] || 1
      pbSet(outcome_variable, 0)
      $game_temp.clear_battle_rules
      return false
    end
    return super
  end
end
TrainerBattle.singleton_class.prepend(ChallengeClauses_TrainerBattleStart)

#===============================================================================
# Sleep Clause - command selection and status infliction.
#===============================================================================
module ChallengeClauses_BattlerSleep
  # Prevent selecting guaranteed sleep status moves while the target side
  # already has a sleeping Pokémon. This also makes them unusable if another
  # effect tries to force their use while the clause is occupied.
  def pbCanChooseMove?(move, commandPhase, showMessages = true, specialUsage = false)
    if ChallengeClauses.guaranteed_sleep_move_blocked?(@battle, self, move)
      if showMessages
        msg = _INTL("{1} can't use {2} because of Sleep Clause!", pbThis, move.name)
        if commandPhase
          @battle.pbDisplayPaused(msg)
        else
          @battle.pbDisplay(msg)
        end
      end
      return false
    end
    return super
  end

  # Central status gate. This catches Spore/Hypnosis/etc. as well as sleep
  # secondary effects such as Relic Song, Dire Claw-style effects, abilities,
  # and other effects that correctly ask whether sleep can be inflicted.
  def pbCanInflictStatus?(newStatus, user, showMessages, move = nil, ignoreStatus = false)
    if newStatus == :SLEEP && ChallengeClauses.sleep_blocked_for?(@battle, user, self)
      if showMessages
        @battle.pbDisplay(_INTL("Sleep Clause prevents another Pokémon on that team from falling asleep!"))
      end
      return false
    end
    return super
  end

  # Yawn checks sleep separately when its delayed effect resolves. Track the
  # original Yawn user so :PLAYER_ONLY scope can still be enforced correctly.
  attr_accessor :challenge_clause_yawn_source_index

  def pbCanSleepYawn?
    if ChallengeClauses.sleep_clause_active?(@battle)
      source = @challenge_clause_yawn_source_index
      if ChallengeClauses.source_is_restricted_by_sleep_clause?(@battle, source) &&
         ChallengeClauses.side_has_sleeping_pokemon?(@battle, @index & 1)
        return false
      end
    end
    return super
  end
end
Battle::Battler.prepend(ChallengeClauses_BattlerSleep)

#===============================================================================
# Remember who caused Yawn so the delayed sleep can obey the configured scope.
#===============================================================================
module ChallengeClauses_YawnSource
  def pbEffectAgainstTarget(user, target)
    super
    if target.effects[PBEffects::Yawn] && target.effects[PBEffects::Yawn] > 0
      target.challenge_clause_yawn_source_index = user.index
    end
  end
end

if defined?(Battle::Move::SleepTargetNextTurn)
  Battle::Move::SleepTargetNextTurn.prepend(ChallengeClauses_YawnSource)
end
