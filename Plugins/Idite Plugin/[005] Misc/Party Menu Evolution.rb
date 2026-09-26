#===============================================================================
# Adds an "Evolve" command to the Pokémon party menu whenever the selected
# Pokémon currently satisfies one of its normal level-up evolution checks.
#===============================================================================

module ManualPartyEvolution
  MENU_ORDER = 45

  # Returns the species this Pokémon can evolve into right now, or nil.
  def self.available_evolution(pkmn)
    return nil if !pkmn
    return pkmn.check_evolution_on_level_up
  end

  # Performs the normal Essentials evolution scene.
  def self.evolve(screen, pkmn, new_species)
    return if !pkmn || !new_species

    pbFadeOutInWithMusic do
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      screen.pbRefresh
    end
  end
end

MenuHandlers.add(:party_menu, :manual_evolve, {
  "name"      => _INTL("Evolve"),
  "order"     => ManualPartyEvolution::MENU_ORDER,

  # Only show the command when the Pokémon can evolve right now.
  "condition" => proc { |screen, party, party_idx|
    pkmn = party[party_idx]
    next !ManualPartyEvolution.available_evolution(pkmn).nil?
  },

  "effect"    => proc { |screen, party, party_idx|
    pkmn = party[party_idx]
    new_species = ManualPartyEvolution.available_evolution(pkmn)

    # Re-check when the command is actually selected, in case the state changed.
    if !new_species
      screen.pbDisplay(_INTL("{1} can't evolve right now.", pkmn.name))
      next
    end

    ManualPartyEvolution.evolve(screen, pkmn, new_species)
  }
})
