=begin
This method can be called in a script via "pbGenSpecialEgg(P, text = "custom message, if you want one.")"
It's damn near the same as pbGenerateEgg, with two very important distinctions:

3 RANDOM IVs are guaranteed to be perfect
1/100 Shiny Odds. 
=end

def pbGenerateSpecialEgg(pkmn, form = nil, text = "")
    return false if !pkmn || $player.party_full?
    pkmn = Pokemon.new(pkmn, Settings::EGG_LEVEL) if !pkmn.is_a?(Pokemon)
    # Set egg's details
    pkmn.name           = _INTL("Egg")
    pkmn.steps_to_hatch = pkmn.species_data.hatch_steps
    pkmn.obtain_text    = text
    # Set 3 random IVs to perfect 
    # As you'd probably guess, that 3 at the very end can be changed to
    # increase/decrease the number of perfect IVs.
    perfect_iv_stats = [:HP, :ATTACK, :DEFENSE, :SPECIAL_ATTACK, :SPECIAL_DEFENSE, :SPEED].sample(3)
    perfect_iv_stats.each { |stat| pkmn.iv[stat] = 31 }
    # Set shiny chance to 1/100 || 1/64 if player has Shiny Charm
    shiny_chance = $bag.has?(:SHINYCHARM) ? 64 : 100
    if rand(shiny_chance) == 0
      pkmn.shiny = true
    end
    # Recalculate stats
    # You can do all sorts of wacky shit in here, if you want to. For example:
    # pkmn.poke_ball = :BEASTBALL
    # pkmn.givePokerus
    # pkmn.item = PPUP
    # Any way you can edit a Pokemon is valid in here. Go nuts, man.
	pkmn.form = form if !form.nil?
    pkmn.poke_ball = :LUXURYBALL
    pkmn.calc_stats
    # Add egg to party
    $player.party[$player.party.length] = pkmn
    return true
  end
  
  alias pbAddSpecialEgg pbGenerateSpecialEgg
  alias pbGenSpecialEgg pbGenerateSpecialEgg
  
  