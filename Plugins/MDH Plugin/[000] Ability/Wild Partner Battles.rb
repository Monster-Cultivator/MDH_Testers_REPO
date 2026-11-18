# Wild allies use the partner slot with their own entrance.
module WildPartnerBattleIntro
  def pbDisplayBrief(message)
    partner = @player[1]
    if partner && partner.trainer_type == :WILDPARTNER
      ally = partner.party.first
      if ally
        send_out = _INTL("{1} sent out {2}!", partner.full_name, ally.name)
        message = message.sub(send_out, _INTL("Wild {1} joined the battle!", ally.name))
      end
    end
    super(message)
  end
end

module WildPartnerEntrance
  def createProcesses
    return super unless @trainer && @trainer.trainer_type == :WILDPARTNER

    pokemon_sprite = @sprites["pokemon_#{@battler.index}"]
    shadow_sprite = @sprites["shadow_#{@battler.index}"]
    pokemon = addSprite(pokemon_sprite, PictureOrigin::BOTTOM)
    pokemon.setDelta(0, -48, 0)
    pokemon.setVisible(0, true)
    pokemon.moveDelta(0, 8, 48, 0)
    if @shadowVisible
      shadow = addSprite(shadow_sprite, PictureOrigin::CENTER)
      shadow.setVisible(8, true)
    end
  end
end

Battle.prepend(WildPartnerBattleIntro)
Battle::Scene::Animation::PokeballPlayerSendOut.prepend(WildPartnerEntrance)
