module PWTSettings
# Information pertining to the start position on the PWT stage
# Format is as following: [map_id, map_x, map_y]
PWT_MAP_DATA = [355,21,14]
# ID for the event used to move the player and opponents on the map
PWT_MOVE_EVENT = 37
# ID of the opponent event
PWT_OPP_EVENT = 35
# ID of the scoreboard event
PWT_SCORE_BOARD_EVENT = 34
# ID of the lobby trainer event
PWT_LOBBY_EVENT = 6
# ID of the event used to display an optional even if the player wins the PWT
PWT_FANFARE_EVENT = 38
# If marked as true, it will apply a multiplier based on the player's current win streak. Defeault to false.
PWT_STREAK_MULT = true
# If marked as true, it will use DeltaTime, otherwise, it will use the old frame system
PWT_USE_DELTA_TIME = false
# Target framerate. By default it's usually 60 fps with MKXP-Z.
PWT_DEFAULT_FRAMERATE = 60
end

module GameData
  class PWTTournament
    attr_reader :id
    attr_reader :real_name
    attr_reader :trainers
    attr_reader :condition_proc
	  attr_reader :points_won

    DATA = {}

    extend ClassMethodsSymbols
    include InstanceMethods

    def self.load; end
    def self.save; end

    def initialize(hash)
      @id             = hash[:id]
      @real_name      = hash[:name]          || "Unnamed"
      @trainers       = hash[:trainers]
      @condition_proc = hash[:condition_proc]
      @rules_proc     = hash[:rules_proc]
      @banned_proc    = hash[:banned_proc]
	  @points_won     = hash[:points_won]    || 3
    end

    # @return [String] the translated name of this nature
    def name
      return _INTL(@real_name)
    end
    
    def call_condition(*args)
      return (@condition_proc) ? @condition_proc.call(*args) : true
    end
    def call_rules(*args)
      return (@rules_proc) ? @rules_proc.call(*args) : PokemonChallengeRules.new
    end
    def call_ban_reason(*args)
      return (@banned_proc) ? @banned_proc.call(*args) : nil
    end
  end
end

##################################################################
# The format for defining individual Tournaments is as follows.
##################################################################
=begin
GameData::PWTTournament.register({
  :id => :Tutorial_Tournament,			# Internal name of the Tournament to be called
  :name => _INTL("Kanto Leaders"),		# Display name of the Tournament in the choice selection box
  :trainers => [						# Array that contains all of the posssible trainers in a Tournament. Must have at least 8.
                [:ID,"Trainer Name","Player Victory Dialogue.","Player Lose Dialogue.",Variant Number,"Lobby Dialogue.","Pre-Battle Dialogue.","Post-Battle Dialogue"], # Trainer 1
				[:ID,"Trainer Name","Player Victory Dialogue.","Player Lose Dialogue.",Variant Number,"Lobby Dialogue.","Pre-Battle Dialogue.","Post-Battle Dialogue"]  # Trainer 2, etc
			   ],
										# Trainers follow this exact format. 
										# ID and Trainer Name are mandatory.
										# Victory dialogue will default to "..." if not filled.
										# Lose dialogue will default to "..." is not filled in either here or trainers.txt. If Lose dialogue is filled here, it overrides the defined line from trainers.txt
										# Variant Number will default to 0 if not filled.
										# If there is no Lobby Dialogue they will not appear in the Lobby map
										# Pre- and Post-battle Dialogue is optional and will display nothing if not filled.
  :condition_proc => proc { 			# The conditions under which this Tournament shows up in the choice selection box. Optional.
	next $PokemonGlobal.hallOfFameLastNumber > 0 
  },					
  :rules_proc => proc {|length|			# This defines the rules for the rules for an individual tournament. More rules can be found in the Challenge Rules script sections
	rules = PokemonChallengeRules.new
    rules.addPokemonRule(BannedSpeciesRestriction.new(:MEWTWO,:MEW,:HOOH,:LUGIA,:CELEBI,:KYOGRE,:GROUDON,:RAYQUAZA,
                                                      :DEOXYS,:JIRACHI,:DIALGA,:PALKIA,:GIRATINA,:REGIGIGAS,:HEATRAN,:DARKRAI,
                                                      :SHAYMIN,:ARCEUS,:ZEKROM,:RESHIRAM,:KYUREM,:LANDORUS,:MELOETTA,
                                                      :KELDEO,:GENESECT))
    rules.addPokemonRule(NonEggRestriction.new)
    rules.addPokemonRule(AblePokemonRestriction.new)
    rules.setNumber(length)
    rules.setLevelAdjustment(FixedLevelAdjustment.new(50))
	next rules
  },
  :banned_proc => proc {				# Displays a message when a team is ineligable to be used in a tournament.
	pbMessage(_INTL("Certain exotic species, as well as eggs, are ineligible.\\1"))
  },
  :points_won => 2						# A configurable amount of Battle Points won after a tournament.
})
=end
##################################################################


GameData::PWTTournament.register({
  :id => :Kanto_Leaders,
  :name => _INTL("Kanto Leaders"),
  :trainers => [
                [:LEADER_Brock,"Brock","Your Pokémon's powerful attacks overcame my rock-hard resistance...\nYou're stronger than I expected...","My barrier was tough to break. Maybe next time.",1,"You were pretty tough! I can't wait to face off against you again!","I'm Brock! I'm an expert on Rock-type Pokémon.","Brock: I really enjoyed the battle with you.\nStill, the world is huge! I can't believe you got past my rock-hard defense!"],
                [:LEADER_Misty,"Misty","You are a skilled Trainer, I have to admit that.","Looks like out of the two of us, I was the better Trainer.",1,"I'm going to train even harder, so that I can beat you next time!"],
                [:LEADER_Surge,"Lt.Surge","You shocked my very core, soldier!","At ease son, not everyone can beat me.",1,"Do you feel this electrifying atmosphere? I'm so pumped!","Prepare for war, kid!","I took a bullet seed back in Poke-Nam for this."],
                [:LEADER_Erika,"Erika","Oh my! \nLooks like I've underestimated you.","Keep practicing hard, and one day you will be the victor.",1,"My Pokémon have bloomed ever since they've battled you."],
                [:LEADER_Sabrina,"Sabrina","Impossible! I did not predict this!","The outcome was just as I predicted.",1,"The future tells me of our rematch."],
                [:LEADER_Koga,"Koga","You've got a great battle technique!","My technique was the superior one!",1],
                [:LEADER_Blaine,"Blaine","Your flame burnt me up!","My flames are not something everyone can handle.",1,"You really burned me up back there!"],
                [:LEADER_Giovanni,"Giovanni","What? \nMe, lose?!","I could have never lost to a kid like you!",1]
               ],
  :rules_proc => proc {|length|
    rules = PokemonChallengeRules.new
    rules.addPokemonRule(BannedSpeciesRestriction.new(:HOOH,:LUGIA,:CELEBI,:KYOGRE,:GROUDON,:RAYQUAZA,
                                                      :DEOXYS,:JIRACHI,:DIALGA,:PALKIA,:GIRATINA,:REGIGIGAS,:HEATRAN,:DARKRAI,
                                                      :SHAYMIN,:ARCEUS,:ZEKROM,:RESHIRAM,:KYUREM,:MELOETTA,
                                                      :KELDEO,:GENESECT,:XERNEAS,:YVETAL,:ZYGARDE,:DIANCIE,:HOOPA,:VOLCANION,
                                                      :COSMOG,:COSMOEM,:SOLGALEO, :LUNALA,:MAGEARNA,:MARSHADOW,:ZERAORA,
                                                      :MELTAN,:MELMETAL,:ZACIAN,:ZAMAZENTA,:ETERNATUS,:CALYREX,:ZARUDE,
                                                      :KORAIDON,:MIRAIDON,:TERAPAGOS,:PECHARUNT
                                                      ))
    rules.addPokemonRule(NonEggRestriction.new)
    rules.addPokemonRule(AblePokemonRestriction.new)
    rules.setNumber(length)
    rules.setLevelAdjustment(FixedLevelAdjustment.new(50))
    next rules
  },
  :banned_proc => proc {
    pbMessage(_INTL("Certain exotic species, as well as eggs, are ineligible.\\1"))
  },
  :points_won => 2
})

#Johto Leaders
GameData::PWTTournament.register({
  :id => :Johto_Leaders,
  :name => _INTL("Johto Leaders"),
  :trainers => [
                [:LEADER_Falkner,"Falkner","Your battle style is impressive, but you still have room to soar.","Your wings are strong, but not strong enough to reach the skies I protect.",1,"There’s nothing like the wind in your face and the thrill of flight. I strive to guide trainers to reach their highest potential.","I’m Falkner, the Flying-type Gym Leader. Let’s see if you can keep up with my soaring strategies!","That was a well-fought battle! Keep aiming high, and you’ll touch the sky one day!"],
                [:LEADER_Bugsy,"Bugsy","Squashed!","You’ve done your homework, but my Bug-types are in a class of their own.",1,"I’ve always been fascinated by the intricate lives of Bug-type Pokémon. They may be small, but they’re incredibly resilient and full of surprises.\nI believe that true knowledge comes from understanding even the tiniest details.","I’m Bugsy, and my Bug-type Pokémon will put your knowledge to the test!","You’ve shown great knowledge, but remember: there’s always more to discover. Keep studying, and you’ll go far!"],
                [:LEADER_Whitney,"Whitney","Womp Womp! Miltank goes BRRRRRR","Aww, you were so close! But my Pokémon are just too tough!",1,"Whitney: I love cute Pokémon, but don’t let their looks fool you! They’re as tough as they come!\nI’ve learned that there’s strength in embracing what you love. Whether it’s battling or just having fun, I always put my heart into it.","I’m Whitney, and my adorable Pokémon are ready to give you a tough challenge!","That was a fun battle! Keep up the good work, and don’t forget to have fun along the way!"],
                [:LEADER_Morty,"Morty","You’ve glimpsed into the unknown, but there’s still much to uncover.","Your spirit is strong, but my connection to the other side is even stronger.",1,"I’ve always been drawn to the mysteries of the world and the connection between life and the afterlife. As a medium, I strive to deepen my understanding of the unseen.\nThere’s a certain calmness in accepting the unknown, but also a challenge in trying to understand it.","I’m Morty, and I’ll guide you through the mysteries of the spirit world with my Ghost-type Pokémon!","That was a battle shrouded in mystery! Keep seeking the unknown, and you’ll find your way."],
                [:LEADER_Chuck,"Chuck","Washed away! I need to train even further.","You’ve got strength, but you need to refine your focus.",1,"Strength comes from both the body and the mind. I train every day to maintain my peak condition. It’s not just about physical power; mental discipline is just as important.","I’m Chuck, and I’ll show you the true power of my Fighting-type Pokémon!","That was a powerful battle! Keep training hard, and you’ll become even stronger!"],
                [:LEADER_Jasmine,"Jasmine","Your heart is strong, and that’s what truly matters.","You’ve shown strength, but my Steel-types are as unyielding as ever.",2,"I’ve always believed that true strength comes from kindness and compassion. As a Gym Leader, I strive to protect others and guide them with a gentle hand. Steel may be tough, but it can also be caring: just like me and my Pokémon.","I’m Jasmine, and I’ll defend my title with the strength of my Steel-type Pokémon!","That was a solid battle! Keep nurturing your bond with your Pokémon, and you’ll be unstoppable!"],
                [:LEADER_Pryce,"Pryce","You’ve proven your worth, but there’s always a tougher challenge ahead.","Your resolve is admirable, but I remain unbroken.",1,"Life has taught me that endurance and patience are the keys to victory. As a Gym Leader, I’ve weathered many storms, and I know that true strength lies in standing firm through adversity. I’ll pass on this wisdom to those who challenge me.","I’m Pryce, and I’ll test your endurance with the chill of my Ice-type Pokémon!","That was a cool-headed battle! Stay strong, and you’ll withstand any storm!"],
                [:LEADER_Clair,"Clair","Meet me in the Dragon's Den, punk.","Your skills are sharp, but you’re still not ready to face the Dragon Clan!",1,"As a member of the Dragon Clan, I’ve always been proud of my heritage and the power that comes with it. Dragons are the mightiest of all Pokémon, and I’ve dedicated my life to mastering them.\nMy pride drives me to be the best, and I expect nothing less from those who challenge me.","I’m Clair, and I’ll show you the might of Dragon-type Pokémon: the ultimate test of your skills!","That was a fierce battle! Keep striving to be the best, and maybe one day you’ll rival a Dragon Master!"]
               ],
  :condition_proc => proc { $stats.pwt_wins.values.sum > 1 },
  :rules_proc => proc {|length|
    rules = PokemonChallengeRules.new
    rules.addPokemonRule(BannedSpeciesRestriction.new(:MEWTWO,:MEW,:KYOGRE,:GROUDON,:RAYQUAZA,
                                                      :DEOXYS,:JIRACHI,:DIALGA,:PALKIA,:GIRATINA,:REGIGIGAS,:HEATRAN,:DARKRAI,
                                                      :SHAYMIN,:ARCEUS,:ZEKROM,:RESHIRAM,:KYUREM,:MELOETTA,
                                                      :KELDEO,:GENESECT,:XERNEAS,:YVETAL,:ZYGARDE,:DIANCIE,:HOOPA,:VOLCANION,
                                                      :COSMOG,:COSMOEM,:SOLGALEO, :LUNALA,:MAGEARNA,:MARSHADOW,:ZERAORA,
                                                      :MELTAN,:MELMETAL,:ZACIAN,:ZAMAZENTA,:ETERNATUS,:CALYREX,:ZARUDE,
                                                      :KORAIDON,:MIRAIDON,:TERAPAGOS,:PECHARUNT
                                                      ))
    rules.addPokemonRule(NonEggRestriction.new)
    rules.addPokemonRule(AblePokemonRestriction.new)
    rules.setNumber(length)
    rules.setLevelAdjustment(FixedLevelAdjustment.new(50))
    next rules
  },
  :banned_proc => proc {
    pbMessage(_INTL("Certain exotic species, as well as eggs, are ineligible.\\1"))
  },
  :points_won => 8
})

#Hoenn Leaders
GameData::PWTTournament.register({
  :id => :Hoenn_Leaders,
  :name => _INTL("Hoenn Leaders"),
  :trainers => [
              [:LEADER_Roxanne,"Roxanne","School's out!","School's in session!",3,"Guiding trainers to reach their full potential - that's why I became a teacher and a Gym Leader!\nKnowledge is the bedrock of any strong strategy, and I’m here to help you lay that foundation.","I’m Roxanne, and I’ll show you the strength of Rock-type Pokémon and a solid strategy!","You’ve got a strong foundation! Keep building on it, and you’ll go far!"],
              [:LEADER_Brawly,"Brawly","Whoa! You’ve got some serious muscle!","You’re strong, but you’ve gotta push yourself even harder!",3,"The ocean waves and the heat of battle—they both get my adrenaline pumping! I live for the thrill of pushing my limits, whether it’s surfing or training my Fighting-types. There’s always room to grow stronger!","I’m Brawly, and I’m gonna hit you like a tidal wave with my Fighting-type Pokémon!","Keep training hard, and you’ll ride the waves of victory!"],
              [:LEADER_Wattson,"Wattson","You’ve got a real spark! Keep it up!","You’ve got energy, but my Pokémon were fully charged!",3,"Haha! I love a good jolt of excitement, whether it’s from a great battle or a clever invention.\nI’m always charged up and ready for action!","I’m Wattson, and I’ll give you a shock with my Electric-type Pokémon!","That was an electrifying battle! Keep that energy up, and you’ll shine bright!"],
              [:LEADER_Flannery,"Flannery","Phew! That was a heated battle. You’ve earned my respect!","You’re hot, but I’m still burning with passion!",3,"Being a Gym Leader is a lot of pressure, but I’m determined to live up to my family’s legacy. I bring all my fiery passion into each battle, and I hope to inspire others to do the same. Don’t be afraid to let your flames burn bright!","I’m Flannery, and I’ll turn up the heat with my Fire-type Pokémon!","That was a scorching battle! Keep your passion burning, and you’ll blaze a trail!"],
              [:LEADER_Norman,"Norman","You remind me of my kid...\nThey'd kick your ass, though.","Your growth is impressive, but there’s always more to learn.",3,"As a father and a Gym Leader, I’ve always believed in the importance of discipline and perseverance. Strength doesn’t come easy—it’s earned through hard work and dedication. I’m proud to see how much you’ve grown.","I’m Norman, and I’ll test your resolve with my Normal-type Pokémon!","Your strength is remarkable, but never stop striving for more. Keep pushing your limits!"],
              [:LEADER_Winona,"Winona","Smacked Down! What a battle!","Your spirit is strong, but my Flying-types were a gust too powerful.",3,"The skies are my home, and I’ve always believed in the freedom they represent. As a Gym Leader, I seek to inspire others to find their own wings and rise above any challenge. There’s a certain peace in soaring through the clouds, but also a fierce determination to keep flying higher.","I’m Winona, and I’ll show you the true strength of my Flying-type Pokémon!","That was a high-flying battle! Keep aiming for the skies, and you’ll reach new heights!"],
              [:LEADER_Tate,"Tate","...","Your mind is sharp, but mine is sharper!",3,"My job as a Gym Leader is to challenge trainers to think strategically and push their mental limits.\nThe mind is a powerful thing — never underestimate it.","Brace yourself! Even as a solo you shouldn't underestimate my Psychic-type Pokémon!","Your strategies were impressive, but always remember to keep your mind sharp. The mind is your greatest weapon!"],
              [:LEADER_Liza,"Liza","...","Hmph. Pitiful",3,"Well fought. Overcoming the psychic connection I have with my Pokémon is no small feat.","It's time for the solo act!","I'll admit, it's strange to fight without Tate alongside me.\nIt's made me realize I overrely on our psychic connection."],
              [:LEADER_Juan,"Juan","Magnificent. You have trained your Pokémon elegantly.","Your technique is admirable, but you’ll need more polish to defeat me.",3,"I strive for elegance and beauty, whether in battle or in life. True strength, I believe, comes from mastering not just power, but also grace. A battle should be like a dance: fluid, poised, and unforgettable.","I am Juan, and I shall dazzle you with the beauty and strength of my Water-type Pokémon!","That was a splendid battle! Keep refining your technique, and you’ll shine with elegance!"],
               ],
  :condition_proc => proc { $stats.pwt_wins.values.sum > 3 },
  :rules_proc => proc {|length|
    rules = PokemonChallengeRules.new
    rules.addPokemonRule(BannedSpeciesRestriction.new(:MEWTWO,:MEW,:HOOH,:LUGIA,:CELEBI,
                                                      :DIALGA,:PALKIA,:GIRATINA,:REGIGIGAS,:HEATRAN,:DARKRAI,
                                                      :SHAYMIN,:ARCEUS,:ZEKROM,:RESHIRAM,:KYUREM,:MELOETTA,
                                                      :KELDEO,:GENESECT,:XERNEAS,:YVETAL,:ZYGARDE,:DIANCIE,:HOOPA,:VOLCANION,
                                                      :COSMOG,:COSMOEM,:SOLGALEO, :LUNALA,:MAGEARNA,:MARSHADOW,:ZERAORA,
                                                      :MELTAN,:MELMETAL,:ZACIAN,:ZAMAZENTA,:ETERNATUS,:CALYREX,:ZARUDE,
                                                      :KORAIDON,:MIRAIDON,:TERAPAGOS,:PECHARUNT
                                                      ))
    rules.addPokemonRule(NonEggRestriction.new)
    rules.addPokemonRule(AblePokemonRestriction.new)
    rules.setNumber(length)
    rules.setLevelAdjustment(FixedLevelAdjustment.new(50))
    next rules
  },
  :banned_proc => proc {
    pbMessage(_INTL("Certain exotic species, as well as eggs, are ineligible.\\1"))
  },
  :points_won => 8
})

#Sinnoh Leaders
GameData::PWTTournament.register({
  :id => :Sinnoh_Leaders,
  :name => _INTL("Sinnoh Leaders"),
  :trainers => [
                [:LEADER_Roark,"Roark","Your technique is solid, just like the rocks I cherish!","You’ve got potential, but you're still a few layers short of bedrock.",1,"I love digging up fossils. They’re like hidden treasures from the past! Each one tells a story, and as a Gym Leader, I hope to help uncover the potential in every trainer.","I'm Roark, the Rock-type specialist! Let’s see what you’re made of!","That was a great battle! Keep digging deeper into your potential."],
                [:LEADER_Gardenia,"Gardenia","You’ve really bloomed as a trainer. Well done!","Your strength is like sunlight to my Grass-types. Not enough to burn!",1,"Nature is my greatest inspiration. I find peace among the trees and flowers, and I bring that tranquility into my battles. There’s beauty in every Pokémon, and it's my job to help them shine.","I’m Gardenia, the nature-loving Grass-type expert! Can you handle the power of nature?","You’ve proven your strength. Keep nurturing your Pokémon!"],
                [:LEADER_Maylene,"Maylene","I see now... Your strength comes from both heart and mind.","Your technique is strong, but you need more discipline.",1,"I train every day to strengthen both my body and my Pokémon. Each battle is a step towards becoming stronger and more focused. Discipline and perseverance are key to success.","I’m Maylene, and I won’t hold back my Fighting-type Pokémon!","Your skills pack a real punch! Keep training hard."],
                [:LEADER_Wake,"Crasher Wake","You’ve shown true strength. Keep riding the waves of battle!","You tried to ride the wave, but my Water-types were too much!",1,"I love the thrill of the ring and the rush of the rapids. As a wrestler and Gym Leader, I believe in strength and showmanship. Life should be lived with passion and energy!","Get ready to be swept away by Crasher Wake and my Water-types!","That was a tidal wave of a battle! Keep making a splash!"],
                [:LEADER_Fantina,"Fantina","A lovely finale! Wonderful!","A dazzling performance, but you need more flair!",1,"Oh là là! The art of battle is like a dance, full of grace and beauty. I always strive to put on a show that is as elegant as it is powerful.","I am Fantina, and I shall dazzle you with my Ghost-type Pokémon! En garde!","Such a delightful battle! Keep refining your moves, and you'll be a star!"],
                [:LEADER_Byron,"Byron","Hardcore! Struck down.","You’ve dug deep, but my defense is impenetrable!",1,"I’ve always believed in building a solid foundation. Whether it’s in battle or in life, strength and durability are what matter most. As a father and a Gym Leader, I take pride in protecting what’s important.","I’m Byron, and I’ll show you the unyielding strength of Steel-type Pokémon!","Your challenge was impressive, but my defense held strong. Keep forging your path!"],
                [:LEADER_Candice,"Candice","Brrrilliant! You've shown the spirit to endure even the harshest blizzard!","You're cool, but I’m the coldest!",1,"I love the cold! It makes me feel alive and energized. As a Trainer, you've gotta stay cool under pressure. I always encourage others to find their own inner strength in the face of adversity.","I’m Candice, and I’ll freeze you in your tracks with my Ice-type Pokémon!","That was a chillingly good battle! Keep your cool, and you’ll go far!"],
                [:LEADER_Volkner,"Volkner","You’ve sparked something in me I haven’t felt in a long time. Well done.","Hmph. Pathetic.",1,"I’ve been searching for excitement in battle for a while now. It’s hard to stay motivated when you’ve seen it all, but a good challenge reignites my passion. I’m always looking for that spark.","I’m Volkner, and I’ll jolt you back to reality with my Electric-type Pokémon!","That was electrifying! Keep that spark alive, and you’ll shine even brighter!"],
               ],
  :condition_proc => proc { $stats.pwt_wins.values.sum > 5 },
  :rules_proc => proc {|length|
    rules = PokemonChallengeRules.new
    rules.addPokemonRule(BannedSpeciesRestriction.new(:MEWTWO,:MEW,:HOOH,:LUGIA,:CELEBI,:KYOGRE,:GROUDON,:RAYQUAZA,
                                                      :DEOXYS,:JIRACHI,:ZEKROM,:RESHIRAM,:KYUREM,:MELOETTA,
                                                      :KELDEO,:GENESECT,:XERNEAS,:YVETAL,:ZYGARDE,:DIANCIE,:HOOPA,:VOLCANION,
                                                      :COSMOG,:COSMOEM,:SOLGALEO, :LUNALA,:MAGEARNA,:MARSHADOW,:ZERAORA,
                                                      :MELTAN,:MELMETAL,:ZACIAN,:ZAMAZENTA,:ETERNATUS,:CALYREX,:ZARUDE,
                                                      :KORAIDON,:MIRAIDON,:TERAPAGOS,:PECHARUNT
                                                      ))
    rules.addPokemonRule(NonEggRestriction.new)
    rules.addPokemonRule(AblePokemonRestriction.new)
    rules.setNumber(length)
    rules.setLevelAdjustment(FixedLevelAdjustment.new(50))
    next rules
  },
  :banned_proc => proc {
    pbMessage(_INTL("Certain exotic species, as well as eggs, are ineligible.\\1"))
  },
  :points_won => 8
})

=begin
#Unova Leaders
GameData::PWTTournament.register({
  :id => :Unova_Leaders,
  :name => _INTL("Unova Leaders"),
  :trainers => [
                [:LEADER_CILAN,"Cilan","You cooked here. Great fight!","You’ve cooked up quite the strategy, but it’s not flavorful enough!",1,"Every battle is like a fine dish. It takes the right blend of strategy, timing, and a pinch of creativity to make it truly special. I’m always excited to see what kind of flavor each trainer brings to the table.","I’m Cilan, and I’ll be serving you a full-course battle with my Grass-type Pokémon!","That was a tasty battle! Keep refining your recipe, and you’ll create something truly extraordinary!"],
                [:LEADER_CHILI,"Chili","Ah! Like a creme burlee - I'm all burnt up!","You’ve got some serious heat, but I’m still burning brighter!",1,"I’m all about battling with passion and energy! You've gotta bring the heat and push your limits. When you’re fired up, there’s nothing you can’t accomplish!","I’m Chili, and I’m going to turn up the heat with my Fire-type Pokémon!","That was a scorching battle! Keep your passion burning, and you’ll go far!"],
                [:LEADER_CRESS,"Cress","Weeded out... Good battle!","You’ve got skill, but you need to flow more smoothly through battle.",1,"A well-balanced strategy is the key to victory. I’m always looking for the perfect harmony between offense and defense. It’s all about keeping things smooth and under control.","I’m Cress, and I’ll show you the power of a well-balanced battle with my Water-type Pokémon!","That was a smooth battle! Keep refining your strategy, and you’ll flow effortlessly to victory!"],
                [:LEADER_LENORA,"Lenora","Back to the lab again!","Your strength is impressive, but my experience runs deeper.",1,"I’ve dedicated my life to uncovering the mysteries of the past. I believe that every battle is a chance to learn something new, and that knowledge is the greatest treasure of all.","I’m Lenora, and I’ll dig deep into your strategy with my Normal-type Pokémon!","That was a well-fought battle! Keep seeking knowledge, and you’ll become an even greater trainer!"],
                [:LEADER_BURGH,"Burgh","Creepy!","Your skills are impressive, but my artistry weaves a stronger web.",1,"I’m always inspired by the beauty and intricacy of nature. Bug-type Pokémon are like living works of art — delicate, yet full of hidden strength.\nI strive to express this through every battle, creating something beautiful and powerful.","I’m Burgh, and I’ll show you the elegance and strength of my Bug-type Pokémon!","That was a beautifully executed battle! Keep nurturing your creativity, and you’ll create something truly magnificent!"],
                [:LEADER_ELESA,"Elesa","Dazzling. You'd make a good model!","You’ve got style, but you’re not quite on my level yet.",1,"Confidence and flair - they'll get you far! Every battle is a performance, and I always aim to dazzle the audience with my Electric-type Pokémon. Life is a runway—walk it with your head held high and your spirit shining bright.","I’m Elesa, and I’ll shock you with my electrifying battle style and Electric-type Pokémon!","That was a stunning battle! Keep shining with confidence, and you’ll electrify the world!"],
                [:LEADER_CLAY,"Clay","Bless yer heart, kid.","You’ve got grit, but my Pokémon are as tough as the earth itself.",1,"I value hard work and determination. There ain't no substitute fer getting your hands dirty and digging deep to find success. I expect the same level of toughness from anyone who challenges me.","I’m Clay, and I’ll show you the power of my Ground-type Pokémon: solid as a rock and tough as nails!","You done bested me! Keep 'er goin', and you’ll strike it rich one day!"],
                [:LEADER_SKYLA,"Skyla","Mayday! Shot down!","You’ve soared to new heights, but I’m still the queen of the skies!",1,"Flying has always been my passion, and as a Gym Leader, I bring that same enthusiasm to my battles. There’s nothing like the thrill of soaring through the clouds with my Flying-type Pokémon. I aim to give every challenger a taste of that exhilaration!","I’m Skyla, and I’ll take you on a high-flying adventure with my Flying-type Pokémon!","That was a sky-high battle! Keep reaching for the clouds, and you’ll go far!"],
                [:LEADER_BRYCEN,"Brycen","What a show-stopper!","Your resolve is impressive, but you’ll need more to break the ice.",1,"As both a Gym Leader and an actor, I’ve learned to embrace the cold and keep my emotions in check. I believe that true strength lies in maintaining composure, no matter how harsh the conditions. I strive to teach that lesson to every challenger I face.","I’m Brycen, and I’ll test your mettle with the icy resolve of my Ice-type Pokémon!","That was a chilling battle! Keep your cool, and you’ll conquer any challenge!"],
                [:LEADER_DRAYDEN,"Drayden","Overcoming the might of the Dragon Type is no small feat. Congratulations.","Your strength is commendable, but a true Dragon Master requires more",1,"I’ve dedicated my entire life to mastering the art of battle and the power of Dragon-type Pokémon. Dragons symbolize strength, wisdom, and resilience — traits I value deeply.\nI seek to instill these qualities in every trainer who challenges me.","I’m Drayden, and I’ll show you the true might of Dragon-type Pokémon—the pinnacle of power!","That was a battle worthy of a Dragon Master! Keep honing your strength, and you’ll achieve greatness!"],
                [:LEADER_MARLON,"Marlon","Gnarly! I'm stoked to have battled you.","You’ve got some serious flow, but I’m still riding the bigger wave!",1,"I’ve always felt at home in the water, whether I’m swimming or battling with my Water-type Pokémon. In life, you need to go with the flow and stay relaxed, no matter the situation. Life’s a big ocean - sometimes you ride the waves, and sometimes you gotta dive deep.","I’m Marlon, and I’ll show you the power of my Water-type Pokémon—they’re always ready to make a splash!","That was a wave-riding battle! Keep your cool, and you’ll surf through any challenge!"],
                [:LEADER_CHEREN,"Cheren","You pass. Great battle!","You’ve come far, but there’s still much more to learn.",1,"I used to think I knew everything about raising Pokémon...\nA couple years ago, I journeyed with a Trainer that showed me how much I had yet to learn.\nI hope to instill that in my challengers.","I’m Cheren, and I’ll test your knowledge and skills with my well-rounded team of Normal-type Pokémon!","That was a well-fought battle! Keep learning and growing, and you’ll become an even stronger trainer!"],
                [:LEADER_ROXIE,"Roxie","Ouch! No encore here!","You’ve got some serious noise, but I’m still rocking harder!",1,"Music and battling are my life, and I put my heart into both! If you're passionate enough, your true self will shine through! The louder you play, the stronger you become!","I’m Roxie, and I’m gonna rock your world with my Poison-type Pokémon!","That was a rocking battle! Keep playing your heart out, and you’ll make some serious noise!"],
               ],
  :condition_proc => proc { $stats.pwt_wins.values.sum > 7 },
  :rules_proc => proc {|length|
    rules = PokemonChallengeRules.new
    rules.addPokemonRule(BannedSpeciesRestriction.new(:MEWTWO,:MEW,:HOOH,:LUGIA,:CELEBI,:KYOGRE,:GROUDON,:RAYQUAZA,
                                                      :DEOXYS,:JIRACHI,:DIALGA,:PALKIA,:GIRATINA,:REGIGIGAS,:HEATRAN,:DARKRAI,
                                                      :SHAYMIN,:ARCEUS,:ZEKROM,:RESHIRAM,:KYUREM,:MELOETTA,
                                                      :KELDEO,:GENESECT,:XERNEAS,:YVETAL,:ZYGARDE,:DIANCIE,:HOOPA,:VOLCANION,
                                                      :COSMOG,:COSMOEM,:SOLGALEO, :LUNALA,:MAGEARNA,:MARSHADOW,:ZERAORA,
                                                      :MELTAN,:MELMETAL,:ZACIAN,:ZAMAZENTA,:ETERNATUS,:CALYREX,:ZARUDE,
                                                      :KORAIDON,:MIRAIDON,:TERAPAGOS,:PECHARUNT
                                                      ))
    rules.addPokemonRule(NonEggRestriction.new)
    rules.addPokemonRule(AblePokemonRestriction.new)
    rules.setNumber(length)
    rules.setLevelAdjustment(FixedLevelAdjustment.new(50))
    next rules
  },
  :banned_proc => proc {
    pbMessage(_INTL("Certain exotic species, as well as eggs, are ineligible.\\1"))
  },
  :points_won => 2
})

#Kalos Leaders
GameData::PWTTournament.register({
  :id => :Kalos_Leaders,
  :name => _INTL("Kalos Leaders"),
  :trainers => [
                [:LEADER_VIOLA,"Viola","That's a wrap! A photo finish.","Your effort was good, but my Bug-types are still picture-perfect.",1,"As a photographer and a Gym Leader, I see battles as a way to capture the beauty of Pokémon in action. Every move is like a snapshot, each with its own unique story.\nHone your skills, and you’ll frame the perfect shot in no time!","I’m Viola, and I’ll capture your imagination with the beauty of my Bug-type Pokémon!","That was a picture-perfect battle! Keep focusing on your goals, and you’ll capture many victories!"],
                [:LEADER_GRANT,"Grant","Keep on climbing! You've got skill.","You're not overcoming this mountain!",1,"As a Gym Leader and a rock climber, I believe in pushing my limits and overcoming obstacles. Each battle is a test of endurance and determination, much like scaling a tough climb.\nKeep your resolve strong, and you’ll conquer any challenge!","I’m Grant, and I’ll put your skills to the test with the strength of my Rock-type Pokémon!","That was a solid battle! Keep climbing higher, and you’ll reach new peaks of success!"],
                [:LEADER_KORRINA,"Korrina","Couldn't parry that!","You’ve got some great moves, but my strategy has the real kick!",1,"I’m all about high-energy performances and precision. I believe in combining technique with flair, and that’s what makes my battles exciting and dynamic.\nKeep your energy high, and you’ll find success in every fight!","I’m Korrina, and I’ll challenge you with the strength and speed of my Fighting-type Pokémon!","That was a high-energy battle! Keep training hard, and you’ll become a real powerhouse!"],
                [:LEADER_RAMOS,"Ramos","Clipped away!","Your moves were good, but I’m still the master of the garden!",1,"Gardening has taught me to value patience and growth. Every battle is like tending to a garden — careful, nurturing, and always with an eye on future growth.\nKeep cultivating your skills, and you’ll see your potential bloom!","I’m Ramos, and I’ll show you the depth and resilience of my Grass-type Pokémon!","That was a refreshing battle! Keep nurturing your abilities, and you’ll grow stronger every day!"],
                [:LEADER_CLEMONT,"Clemont","Maybe I can invent something to help you be less of a bitch.","Your strategy was electrifying, but my skills remain unmatched.",1,"As an inventor, I’m fascinated by the power and potential of technology. Every battle is a chance to showcase innovation and creativity.\nStay curious and keep exploring new ideas, and you’ll light up your path to victory!","I’m Clemont, and I’ll challenge you with the cutting-edge energy of my Electric-type Pokémon!","That was an electrifying battle! Keep experimenting, and you’ll find new ways to shine!"],
                [:LEADER_VALERIE,"Valerie","Cool!","You’ve shown some grace... but I’m still the queen of elegance!",1,"I see every battle as a chance to showcase both elegance and strength. Pokémon battles are a dance where every move should be as graceful as it is effective.\nKeep embracing your style, and you’ll dazzle everyone you meet!","I’m Valerie, and I’ll enchant you with the charm and power of my Fairy-type Pokémon!","That was a beautifully executed battle! Keep shining with elegance, and you’ll capture everyone’s attention!"],
                [:LEADER_OLYMPIA,"Olympia","Goodbye, mind meddler.","Your psychic abilities are impressive, but mine are on another plane!",1,"I believe in the power of mental focus and serenity. Battles are a reflection of inner strength and clarity, and I strive to impart that wisdom to every challenger.\nKeep honing your mind, and you’ll achieve great things!","I’m Olympia, and I’ll challenge you with the deep insights and power of my Psychic-type Pokémon!","That was a battle of mental prowess! Keep training your mind, and you’ll find clarity and success!"],
                [:LEADER_WULFRIC,"Wulfric","Broken through! Wish I had been in a good game.","Your moves were strong, but my Ice-types are unbreakable!",1,"The cold is rugged, just like my Pokemon. Every battle is a test of endurance and strength, and I’m always ready to face challenges head-on.\nKeep your resolve strong, and you’ll stand firm against any storm.","I’m Wulfric, and I’ll test your strength with the icy might of my Ice-type Pokémon!","That was a frosty battle! Keep your spirit strong, and you’ll weather any storm that comes your way!"],
               ],
  :condition_proc => proc { $stats.pwt_wins.values.sum > 9 },
  :rules_proc => proc {|length|
    rules = PokemonChallengeRules.new
    rules.addPokemonRule(BannedSpeciesRestriction.new(:MEWTWO,:MEW,:HOOH,:LUGIA,:CELEBI,:KYOGRE,:GROUDON,:RAYQUAZA,
                                                      :DEOXYS,:JIRACHI,:DIALGA,:PALKIA,:GIRATINA,:REGIGIGAS,:HEATRAN,:DARKRAI,
                                                      :SHAYMIN,:ARCEUS,:ZEKROM,:RESHIRAM,:KYUREM,:MELOETTA,
                                                      :KELDEO,:GENESECT,:XERNEAS,:YVETAL,:ZYGARDE,:DIANCIE,:HOOPA,:VOLCANION,
                                                      :COSMOG,:COSMOEM,:SOLGALEO, :LUNALA,:MAGEARNA,:MARSHADOW,:ZERAORA,
                                                      :MELTAN,:MELMETAL,:ZACIAN,:ZAMAZENTA,:ETERNATUS,:CALYREX,:ZARUDE,
                                                      :KORAIDON,:MIRAIDON,:TERAPAGOS,:PECHARUNT
                                                      ))
    rules.addPokemonRule(NonEggRestriction.new)
    rules.addPokemonRule(AblePokemonRestriction.new)
    rules.setNumber(length)
    rules.setLevelAdjustment(FixedLevelAdjustment.new(50))
    next rules
  },
  :banned_proc => proc {
    pbMessage(_INTL("Certain exotic species, as well as eggs, are ineligible.\\1"))
  },
  :points_won => 2
})

#Alola Leaders??? Trial Captains? Honestly IDK
GameData::PWTTournament.register({
  :id => :Alola_Leaders,
  :name => _INTL("Alola's Captains!"),
  :trainers => [
               [:LEADER_ILIMA,"Ilima","You’ve managed to outshine me this time!","You’ve got some great moves, but I still have the advantage with my style!",1,"I have a passion for creative and stylish battles, I believe in making each challenge unique and memorable. Every battle is an opportunity to showcase not just strength but also flair and originality. Keep honing your skills, and you’ll find your own unique style!","I’m Ilima, and I’ll show you the beauty and finesse of my Normal-type Pokémon!","That was a stylish battle! Keep refining your moves, and you’ll create something truly special!"],
               [:LEADER_LANA,"Lana","You’ve made a big splash with your skills!","Your strategy was fluid, but I’m still riding the waves with more power.",1,"I see battles as a way to connect with the natural world. Each move should flow smoothly and harmoniously, just like the water we cherish. Keep nurturing your bond with your Pokémon, and you’ll make waves in no time!","I’m Lana, and I’ll challenge you with the elegance and strength of my Water-type Pokémon!","That was a refreshing battle! Keep flowing with confidence, and you’ll achieve great things!"],
               [:LEADER_KIAWE,"Kiawe","You’ve really turned up the heat in this battle!","Your battle was intense, but my Fire-types are on another level!",1,"I believe in pushing limits and embracing the power of fire. Every battle is a chance to demonstrate passion and strength, and I’m always ready to ignite the field with fiery excitement. Keep the heat up, and you’ll light up your path to victory!","I’m Kiawe, and I’ll test your endurance with the blazing power of my Fire-type Pokémon!","That was a scorching battle! Keep fueling your passion, and you’ll blaze a trail to success!"],
               [:LEADER_MALLOW,"Mallow","You’ve cooked up some strong strategies!","Your effort was impressive, but my Grass-types bring a richer taste to the battle.",1,"I believe in blending strength with the art of cooking. Every battle is a chance to create something delicious and powerful, reflecting both skill and creativity. Keep perfecting your technique, and you’ll cook up a winning strategy!","I’m Mallow, and I’ll show you the depth and flavor of my Grass-type Pokémon!","That was a well-cooked battle! Keep seasoning your skills, and you’ll create something truly exceptional!"],
               [:LEADER_SOPHOCLES,"Sophocles","You’ve outshone my tech-savvy tactics!","Your strategy was clever, but my Electric-types are always on the cutting-edge.",1,"As a Captain and an inventor, I’m always exploring new technologies and strategies to stay ahead. Each battle is a chance to showcase innovation and cleverness. Keep experimenting, and you’ll find new ways to electrify your battles!","I’m Sophocles, and I’ll challenge you with the power and precision of my Electric-type Pokémon!","That was a high-voltage battle! Keep innovating, and you’ll light up your path to victory!"],
               [:LEADER_ACEROLA,"Acerola","Haunting! Great battle.","You’ve shown some spook-tacular moves, but my Ghost-types are truly eerie!",1,"I believe in embracing the unknown and the supernatural. Each battle is a chance to reveal hidden strengths and explore the mysterious side of Pokémon. Keep your spirit strong, and you’ll uncover many more secrets!","I’m Acerola, and I’ll challenge you with the haunting power of my Ghost-type Pokémon!","That was a chilling battle! Keep exploring the unknown, and you’ll uncover many more surprises!"],
               [:LEADER_MINA,"Mina","You're truly an artist of Battle.","Your battle was full of flair, but my Fairy-types have an enchanting edge.",1,"I see battles as a canvas for creativity and charm. Every move should be as captivating and magical as a masterpiece. Keep embracing your artistic side, and you’ll create something truly magical!","I’m Mina, and I’ll dazzle you with the whimsical power of my Fairy-type Pokémon!","That was a magical battle! Keep bringing your creativity to every fight, and you’ll enchant everyone you meet!"],
               [:LEADER_HAPU,"Hapu","You’ve shown a lot of strength to overcome my Ground-types!","Your battle was strong, but my Ground-types have the depth and resilience to prevail.",1,"I take pride in the strength and endurance of my Ground-type Pokémon. Each battle is a test of perseverance and grit, and I’m always ready to stand firm and face any challenge.","I’m Hapu, and I’ll challenge you with the enduring power of my Ground-type Pokémon!","That was a solid battle! Keep your resolve strong, and you’ll ground yourself as a great trainer!"],
               ],
  :condition_proc => proc { $stats.pwt_wins.values.sum > 11 },
  :rules_proc => proc {|length|
    rules = PokemonChallengeRules.new
    rules.addPokemonRule(BannedSpeciesRestriction.new(:MEWTWO,:MEW,:HOOH,:LUGIA,:CELEBI,:KYOGRE,:GROUDON,:RAYQUAZA,
                                                      :DEOXYS,:JIRACHI,:DIALGA,:PALKIA,:GIRATINA,:REGIGIGAS,:HEATRAN,:DARKRAI,
                                                      :SHAYMIN,:ARCEUS,:ZEKROM,:RESHIRAM,:KYUREM,:MELOETTA,
                                                      :KELDEO,:GENESECT,:XERNEAS,:YVETAL,:ZYGARDE,:DIANCIE,:HOOPA,:VOLCANION,
                                                      :COSMOG,:COSMOEM,:SOLGALEO, :LUNALA,:MAGEARNA,:MARSHADOW,:ZERAORA,
                                                      :MELTAN,:MELMETAL,:ZACIAN,:ZAMAZENTA,:ETERNATUS,:CALYREX,:ZARUDE,
                                                      :KORAIDON,:MIRAIDON,:TERAPAGOS,:PECHARUNT
                                                      ))
    rules.addPokemonRule(NonEggRestriction.new)
    rules.addPokemonRule(AblePokemonRestriction.new)
    rules.setNumber(length)
    rules.setLevelAdjustment(FixedLevelAdjustment.new(50))
    next rules
  },
  :banned_proc => proc {
    pbMessage(_INTL("Certain exotic species, as well as eggs, are ineligible.\\1"))
  },
  :points_won => 2
})

#Galar Leaders
GameData::PWTTournament.register({
  :id => :Galar_Leaders,
  :name => _INTL("Galar Leaders"),
  :trainers => [
               [:LEADER_MILO,"Milo","","You’ve got some great moves, but I’m still the top farmer around here!",1,"I’m passionate about nurturing growth and strength. Each battle is a chance to cultivate not just my Pokémon but also the skills of my challengers.\nKeep working hard, and you’ll see your efforts blossom!","I’m Milo, and I’ll show you the growth and power of my Grass-type Pokémon!","That was a fruitful battle! Keep tending to your skills, and you’ll grow stronger every day!"],
               [:LEADER_NESSA,"Nessa","","You’ve made quite a splash, but my Water-types are still riding the waves!",1,"Water is as graceful as it is strong. Every battle is a chance to showcase both agility and strength, just like the ocean’s tides.\nKeep flowing with confidence, and you’ll make waves in the Pokémon world!","I’m Nessa, and I’ll challenge you with the elegance and strength of my Water-type Pokémon!","That was a refreshing battle! Keep riding the waves, and you’ll achieve great things!"],
               [:LEADER_KABU,"Kabu","","You’ve shown some fiery passion, but I’m still the hottest trainer around!",1,"Fiery determination won me a Championship a long time ago!\nIt'll take you far, too.","I’m Kabu, and I’ll challenge you with the intense heat of my Fire-type Pokémon!","That was a scorching battle! Keep fueling your passion, and you’ll set the world ablaze!"],
               [:LEADER_BEA,"Bea","","You’ve got some strong moves, but I’m still the master of Fighting!",1,"You know, I had the chance to become a Gym Leader here. I didn't take it, though.","I’m Bea, and I’ll challenge you with the strength and precision of my Fighting-type Pokémon!","That was a powerful battle! Keep training hard, and you’ll find yourself fighting at the top!"],
               [:LEADER_ALLISTER,"Allister","You’ve managed to uncover my strategy—well done!","Your skills were impressive, but my Ghost-types always have an eerie advantage.",1,"I believe in the power of the unknown. Each battle is an opportunity to explore hidden depths and reveal secrets. Keep embracing the mystery, and you’ll uncover your true potential!","I’m Allister, and I’ll challenge you with the spectral power of my Ghost-type Pokémon!","That was a chilling battle! Keep delving into the unknown, and you’ll find many more surprises!"],
               [:LEADER_OPAL,"Opal","You’ve shown a delightful flair in battle!","Pop Quiz! Who hasn't trained their Pokémon well?\nThat's right - YOU!",1,"Battles are an opportunity to display grace and charm. Each fight is a chance to showcase not just strength but also elegance and whimsy. Keep embracing your unique style, and you’ll enchant everyone you meet!","I’m Opal, and I’ll dazzle you with the enchanting power of my Fairy-type Pokémon!","That was a beautifully magical battle! Keep adding your own flair to every fight, and you’ll capture everyone’s attention!"],
               [:LEADER_GORDIE,"Gordie","You’ve got some solid moves, but I’m still the rock of this Gym!","Your effort was commendable, but I stand firm against any challenge.",1,"Resilience comes from solid foundation. Each battle is a testament to both endurance and skill.\nKeep building your strength, and you’ll become an immovable object!","I’m Gordie, and I’ll test your resolve with the rugged power of my Rock-type Pokémon!","That was a rock-solid battle! Keep your determination strong, and you’ll become a true champion!"],
               [:LEADER_MELONY,"Melony","You’ve shown impressive tenacity in this battle!","Your moves were strong, but my Pokémon are nurtured right.",1,"You've got to nurture your Pokémon! Treat them with love. Though I'm sure you already do...","I’m Melony, and I’ll challenge you with the icy might of my Ice-type Pokémon!","That was a frosty battle! Keep your resolve strong, and you’ll weather any storm that comes your way!"],
               [:LEADER_PIERS,"Piers","You’ve outshone my Rock ‘n’ Roll style!","My Dark-types always have a rebellious edge - no Dynamax required!",1,"Battles are my favorite way to express myself. Each fight is a stage where both strength and attitude shine.\nKeep rocking to your own beat, and you’ll make a lasting impression!","I’m Piers, and I’ll challenge you with the edgy power of my Dark-type Pokémon!","That was a rocking battle! Keep following your own rhythm, and you’ll create a unique path to victory!"],
               [:LEADER_RAIHAN,"Raihan","You’ve weathered the storm with impressive skill!","Your strategy was solid, but my Dragons always soar above the rest.",1,"As a Gym Leader and a champion of the battlefield, I believe in adapting to every challenge with flair and strategy. Each battle is a chance to showcase both strength and tactical prowess. Keep your cool and adaptability, and you’ll rise above any challenge!","I’m Raihan, and I’ll test you with the majestic power of my Dragon-type Pokémon!","That was a dynamic battle! Keep refining your strategy, and you’ll weather any storm that comes your way!"],
               [:LEADER_KLARA,"Klara","Don't be so toxic...","Tee-hee! Looks like I'm the better Trainer!",1,"Each fight is a chance to outwit and outlast... And nobody can outwit me!","I’m Klara, and I’ll challenge you with the sneaky power of my Poison-type Pokémon!","That was a poisonous battle! Keep your strategy sharp, and you’ll find your way to victory!"],
               [:LEADER_AVERY,"Avery","Fuck!","Your strategy was clever, but my Psychic abilities always give me the edge.",1,"I'm hoping to shine in this tournament. If I do, I'm sure I'll be elevated to a full-fledged Gym Leader!","I’m Avery, and I’ll challenge you with the profound power of my Psychic-type Pokémon!","That was a battle of mental prowess! Keep training your mind, and you’ll find clarity and success!"],
               ],
  :condition_proc => proc { $stats.pwt_wins.values.sum > 13 },
  :rules_proc => proc {|length|
    rules = PokemonChallengeRules.new
    rules.addPokemonRule(BannedSpeciesRestriction.new(:MEWTWO,:MEW,:HOOH,:LUGIA,:CELEBI,:KYOGRE,:GROUDON,:RAYQUAZA,
                                                      :DEOXYS,:JIRACHI,:DIALGA,:PALKIA,:GIRATINA,:REGIGIGAS,:HEATRAN,:DARKRAI,
                                                      :SHAYMIN,:ARCEUS,:ZEKROM,:RESHIRAM,:KYUREM,:MELOETTA,
                                                      :KELDEO,:GENESECT,:XERNEAS,:YVETAL,:ZYGARDE,:DIANCIE,:HOOPA,:VOLCANION,
                                                      :COSMOG,:COSMOEM,:SOLGALEO, :LUNALA,:MAGEARNA,:MARSHADOW,:ZERAORA,
                                                      :MELTAN,:MELMETAL,:ZACIAN,:ZAMAZENTA,:ETERNATUS,:CALYREX,:ZARUDE,
                                                      :KORAIDON,:MIRAIDON,:TERAPAGOS,:PECHARUNT
                                                      ))
    rules.addPokemonRule(NonEggRestriction.new)
    rules.addPokemonRule(AblePokemonRestriction.new)
    rules.setNumber(length)
    rules.setLevelAdjustment(FixedLevelAdjustment.new(50))
    next rules
  },
  :banned_proc => proc {
    pbMessage(_INTL("Certain exotic species, as well as eggs, are ineligible.\\1"))
  },
  :points_won => 2
})
=end
