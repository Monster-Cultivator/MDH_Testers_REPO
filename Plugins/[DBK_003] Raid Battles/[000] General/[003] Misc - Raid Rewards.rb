#-------------------------------------------------------------------------------
# Generates a rewards list for this Raid Den.
#-------------------------------------------------------------------------------
def pbGenerateRaidRewards(pokemon, style = :Basic, rank = nil, loot = nil, weather = nil, terrain = nil, environ = nil)
  rewards = []
  rank = pbDefaultRaidProperty(pokemon, :rank, {}) if rank.nil?
  #-----------------------------------------------------------------------------
  # Adds Exp. Candy rewards.
  #-----------------------------------------------------------------------------
  qty = (rank * 1.1).round
  [:EXPCANDYXL, :EXPCANDYL, :EXPCANDYM, :EXPCANDYS, :EXPCANDYXS].each_with_index do |candy, i|
    case candy
    when :EXPCANDYXS then next if rank > 5 || rank == 5 && rand(10) < 4
    when :EXPCANDYS  then next if rank > 5 && rand(10) < 2
    when :EXPCANDYM  then next if rank < 3
    when :EXPCANDYL  then next if rank < 4 || rank == 4 && rand(10) > 2
    when :EXPCANDYXL then next if rank < 5 || rank == 5 && rand(10) > 2
    end
    candyQty = (i == 0) ? (qty / 2).round : qty * i
    rewards.push([candy, candyQty + rand(3)])
  end
  rewards.push([:RARECANDY, qty + rand(-1..2)]) if rank > 2
  #-----------------------------------------------------------------------------
  # Idite: Adds IV Candies to raid loot.
  #-----------------------------------------------------------------------------
=begin OLD METHOD, TREATS ALL CANDIES EQUALLY
  iv_candies = [
    :HEALTHCANDY, :MIGHTYCANDY, :TOUGHCANDY, :SMARTCANDY, :COURAGECANDY, :QUICKCANDY,
    :SICKLYCANDY, :WEAKCANDY, :BRITTLECANDY, :NUMBCANDY, :COWARDCANDY, :SLOWCANDY
  ]
  rolls = rand(0..4) + (rank * 1.1).round
  rolls.times do
    rewards.push([iv_candies.sample, 1])
  end
=end
  # New Method, splits candy pool into positive/negative.
  positive_candies = [
    :HEALTHCANDY, :MIGHTYCANDY, :TOUGHCANDY,
    :SMARTCANDY, :COURAGECANDY, :QUICKCANDY
  ]

  negative_candies = [
    :SICKLYCANDY, :WEAKCANDY, :BRITTLECANDY,
    :NUMBCANDY, :COWARDCANDY, :SLOWCANDY
  ]

  # Positive candies:
  # Rank 1: 0-4 rolls
  # Each rank above 1: +2 rolls
  pos_rolls = rand(0..4) + (rank * 1.1).round
  pos_rolls.times do
    rewards.push([positive_candies.sample, 1])
  end

  # Negative candies:
  # At most one roll total, with only a chance to appear
  if rand(100) < (20 + rank * 5)   # 25% (rank 1) - 45% (rank 5)
    rewards.push([negative_candies.sample, 1])
  end

  #-----------------------------------------------------------------------------
  # Adds rewards related to raid type.
  #-----------------------------------------------------------------------------
  case style
  when :Ultra
    rewards.push([:ZBOOSTER, 1]) if pokemon.isSpecies?(:NECROZMA)
  when :Max
    rewards.push([:DYNAMAXCANDY, qty + rand(-1..2)]) if rank > 2
    rewards.push([:MAXSOUP, 1]) if pokemon.gmax_factor? && rand(2) == 0
    case pokemon.species
    when :VESPIQUEN
      rewards.push([:MAXHONEY, 1])
    when :PARASECT, :BRELOOM, :AMOONGUS, :SHIINOTIC, :TOEDSCRUEL
      rewards.push([:MAXMUSHROOMS, 1])
	when :MAHOKE, :SAWK, :THROH, :MACHOP, :MAKUHITA
      rewards.push([:BLACKBELT, 1])
	when :CLOYSTER, :SWALOT, :SHELLDER, :GULPIN
      rewards.push([:BIGPEARL, 1])
	  rewards.push([:PEARL, 1])
    when :ETERNATUS
      rewards.push([:WISHINGSTAR, 1])
    end
  when :Tera
    shardQty = qty + rand(-1..2)
    shard = GameData::Item.get_shard_from_type(pokemon.tera_type)
    if $bag.has?(:GLIMMERINGCHARM)
      case rank
      when 3 then shardQty += 2
      when 4 then shardQty += 5
      when 5 then shardQty += 10
      when 6 then shardQty += 12
      when 7 then shardQty += 20
      end
    end
    rewards.push([shard, shardQty]) if shard
    rewards.push([:MYSTERYTERAJEWEL, 1]) if rand(10) < 2
    rewards.push([:RADIANTTERAJEWEL, 1]) if pokemon.isSpecies?(:TERAPAGOS)
  end
  #-----------------------------------------------------------------------------
  # Adds TM/TR reward.
  #-----------------------------------------------------------------------------
  if rank > 2
    types = (style == :Tera) ? [pokemon.tera_type] : pokemon.types
    machine = GameData::Item.get_TR_from_type(types)
    rewards.push([machine, 1]) if machine
  end
  #-----------------------------------------------------------------------------
  # Adds general rewards.
  #-----------------------------------------------------------------------------
  itemQty = [1, (qty / 2 + rand(-1..2)).round].max
  berries = [:POMEGBERRY, :KELPSYBERRY, :QUALOTBERRY, :HONDEWBERRY, :GREPABERRY, :TAMATOBERRY]
  rewards.push([berries.sample, itemQty])
  if rank > 3
    mints = [
      :SERIOUSMINT,                                          # - Neutral
      :LONELYMINT, :ADAMANTMINT, :NAUGHTYMINT, :BRAVEMINT,   # + Attack
      :BOLDMINT,   :IMPISHMINT,  :LAXMINT,     :RELAXEDMINT, # + Defense
      :MODESTMINT, :MILDMINT,    :RASHMINT,    :QUIETMINT,   # + Sp.Atk
      :CALMMINT,   :GENTLEMINT,  :CAREFULMINT, :SASSYMINT,   # + Sp.Def
      :TIMIDMINT,  :HASTYMINT,   :JOLLYMINT,   :NAIVEMINT    # + Speed
    ]
    rewards.push([mints.sample, 1])
  end
  itemQty = [1, (qty / 2 + rand(-1..2)).round].max
  feathers = [:HEALTHFEATHER, :MUSCLEFEATHER, :RESISTFEATHER, :GENIUSFEATHER, :CLEVERFEATHER, :SWIFTFEATHER]
  rewards.push([feathers.sample, itemQty])
  if rank > 2
    val = (rank > 5) ? 2 : 4
    itemQty = [1, (qty / val + rand(-1..2)).round].max
    vitamins = [:HPUP, :PROTEIN, :IRON, :CALCIUM, :ZINC, :CARBOS]
    rewards.push([vitamins.sample, itemQty])
    if rand(10) < 4
      training = [:PPUP, :PPMAX, :ABILITYCAPSULE, :ABILITYPATCH, :BOTTLECAP, :GOLDBOTTLECAP]
      rewards.push([training.sample, 1])
    end
    if rand(10) < 2
      case rank
      when 3    then treasure = [:TINYMUSHROOM, :NUGGET, :PEARL, :RELICCOPPER, :RELICVASE]
      when 4, 5 then treasure = [:BIGMUSHROOM, :BIGNUGGET, :BIGPEARL, :RELICSILVER, :RELICBAND]
      when 6, 7 then treasure = [:BALMMUSHROOM, :PEARLSTRING, :RELICGOLD, :RELICSTATUE, :RELICCROWN]
      end
      rewards.push([treasure.sample, 1])
    end
  end
  if rand(6) <= rank
    apriballs = [:HEAVYBALL, :LUREBALL, :FRIENDBALL, :LOVEBALL, :LEVELBALL, :FASTBALL, :MOONBALL, :DREAMBALL, :BEASTBALL]
	rewards.push([apriballs.sample, 1])
  end
  #-----------------------------------------------------------------------------
  # Adds environmental rewards.
  #-----------------------------------------------------------------------------
  if rand(10) < 1
    case weather
    when :Sun         then rewards.push([:HEATROCK,      1])
    when :Rain        then rewards.push([:DAMPROCK,      1])
    when :Sandstorm   then rewards.push([:SMOOTHROCK,    1])
    when :Hail        then rewards.push([:ICYROCK,       1])
    when :ShadowSky   then rewards.push([:LIFEORB,       1])
    when :Fog         then rewards.push([:SMOKEBALL,     1])
    end
  end
  if rand(10) < 1
    case terrain              
    when :Electric    then rewards.push([:ELECTRICSEED,  1])
    when :Grassy      then rewards.push([:GRASSYSEED,    1])
    when :Misty       then rewards.push([:MISTYSEED,     1])
    when :Psychic     then rewards.push([:PSYCHICSEED,   1])
    end
  end
  if rand(10) < 1
    case environ
    when :None        then rewards.push([:CELLBATTERY,   1])    
    when :Grass       then rewards.push([:MIRACLESEED,   1])
    when :TallGrass   then rewards.push([:ABSORBBULB,    1])
    when :MovingWater then rewards.push([:MYSTICWATER,   1])
    when :StillWater  then rewards.push([:FRESHWATER,    1])
    when :Puddle      then rewards.push([:LIGHTCLAY,     1])
    when :Underwater  then rewards.push([:SHOALSHELL,    1])    
    when :Cave        then rewards.push([:LUMINOUSMOSS,  1])
    when :Rock        then rewards.push([:HARDSTONE,     1])
    when :Sand        then rewards.push([:SOFTSAND,      1])
    when :Forest      then rewards.push([:SHEDSHELL,     1])
    when :ForestGrass then rewards.push([:SILVERPOWDER,  1])
    when :Snow        then rewards.push([:SNOWBALL,      1])
    when :Ice         then rewards.push([:NEVERMELTICE,  1])
    when :Volcano     then rewards.push([:CHARCOAL,      1])
    when :Graveyard   then rewards.push([:RAREBONE,      1])
    when :Sky         then rewards.push([:PRETTYFEATHER, 1])
    when :Space       then rewards.push([:STARDUST,      1])
    when :UltraSpace  then rewards.push([:COMETSHARD,    1])
    end
  end
  #-----------------------------------------------------------------------------
  # Adds manually entered rewards.
  #-----------------------------------------------------------------------------
  if loot
    if loot.is_a?(Array)
      loot.each do |itm|
        case itm
        when Array
          rewards.push(itm)
        when Symbol
          rewards.push([itm, 1])
        end
      end
    else 
      rewards.push([loot, 1])
    end
  end
  #-----------------------------------------------------------------------------
  # Finalizes all rewards.
  #-----------------------------------------------------------------------------
  final_rewards = {}
  rewards.each do |reward|
    next if !GameData::Item.exists?(reward[0])
    if final_rewards.has_key?(reward[0])
      final_rewards[reward[0]] += reward[1]
    else
      final_rewards[reward[0]] = reward[1]
    end
  end
  return final_rewards
end