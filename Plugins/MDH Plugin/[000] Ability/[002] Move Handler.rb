class Battle::Move::HitOncePerUserHoundoom < Battle::Move
  def multiHitMove?; return true; end

  def pbMoveFailed?(user, targets)
    @beatUpList = []
    @battle.eachInTeamFromBattlerIndex(user.index) do |pkmn, i|
      next if !pkmn.able? || pkmn.status != :NONE
	  next if !pkmn.isSpecies?(:HOUNDOOMh) || !pkmn.isSpecies?(:HOUNDOOMh_1)
	  next if !pkmn.hasMove?(:BEATUPEX)
      @beatUpList.push(i)
    end
    if @beatUpList.length == 0
      @battle.pbDisplay(_INTL("The gang wasn't ready!"))
      return true
    end
    return false
  end

  def pbNumHits(user, targets)
    return @beatUpList.length
  end

  def pbBaseDamage(baseDmg, user, target)
    i = @beatUpList.shift   # First element in array, and removes it from array
    atk = @battle.pbParty(user.index)[i].baseStats[:ATTACK]
    return 7 + (atk / 10)
  end
end
