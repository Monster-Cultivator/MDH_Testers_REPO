module QuestModule
  
  # Here's the simplest example of a single-stage quest with everything specified
  Quest1 = {
    :ID => "1",
    :Name => "Package Delivery",
    :QuestGiver => "Lina",
    :Stage1 => "Deliver a package to Norman",
    :Location1 => "Petalburg City",
    :QuestDescription => "Lina needs us to ran a package to her husband",
    :RewardString => "Something shiny!"
  }
  
  # Here's an extension of the above that includes multiple stages
  Quest2 = {
    :ID => "2",
    :Name => "Town Protector",
    :QuestGiver => "Little Girl",
    :Stage1 => "Give her a Zigzagoon.",
    :Location1 => "Littleroot Town",
    :QuestDescription => "The Little Girl who stands guard at the entrance of Littleroot Town wants a Zigzagoon to assist her, go and catch one for her!",
    :RewardString => "Something shiny!"
  }
  
  # Here's an example of a quest with lots of stages that also doesn't have a stage location defined for every stage
  Quest3 = {
    :ID => "3",
    :Name => "Building a Winning Team!",
    :QuestGiver => "Hex Maniac",
    :Stage1 => "Catch a Drifloon",
    :Stage2 => "Catch a Pumpkaboo",
    :Stage3 => "Catch a Nincada",
    :Stage4 => "Catch a Phantump",
    :Location1 => "nil",
    :QuestDescription => "Help the Hex Maniac catch a Drifloon and Nincada (Route 116), Pumpkaboo and Phantump (Petalburg Woods)",
    :RewardString => "Chicken soup!"
  }
  
  # Here's an example of not defining the quest giver and reward text
  Quest4 = {
    :ID => "4",
    :Name => "Emotion known as rage",
    :QuestGiver => "Whitney",
    :Stage1 => "Seek out the mad Ralts!",
    :Stage2 => "It's still on a rampage!",
    :Location1 => "Route 104",
    :Location2 => "Route 103",
    :QuestDescription => "There's a rampaging Ralts taking out Trainers! Whitney has tasked you to subdue the threat!",
    :RewardString => "Experience!"
  }
  
  # Other random examples you can look at if you want to fill out the UI and check out the page scrolling
  Quest5 = {
    :ID => "5",
    :Name => "Thank you for being a friend",
    :QuestGiver => "May",
    :Stage1 => "Petalburg Woods",
    :QuestDescription => "Retrieve May's pendant",
    :RewardString => "Something interesting"
  }
  
  Quest6 = {
    :ID => "6",
    :Name => "Packed with Love",
    :QuestGiver => "Johanna",
    :Stage1 => "Deliver the supplies to Dawn.",
	:Stage2 => "Tell Johanna the news",
    :Location1 => "Dewford Town",
    :QuestDescription => "Johanna wants you to check up on her daughter Dawn and deliver a package to her",
    :RewardString => "nil"
  }
  
  Quest7 = {
    :ID => "7",
    :Name => "Bunch of Berries",
    :QuestGiver => "Student",
    :Stage1 => "Give the student 5 Oran Berries.",
    :Location1 => "Rustboro City School",
    :QuestDescription => "The student seems to have an interest in Berries, might as well help him out?",
    :RewardString => "A Cool Berry."
  }
  
  Quest8 = {
    :ID => "8",
    :Name => "Escort Mission!",
    :QuestGiver => "Caroline",
    :Stage1 => "Get Birch for date night!",
    :Stage2 => "Find the Professor's journal",
    :Location1 => "Birch's Lab",
    :Location2 => "Route 115",
    :QuestDescription => "Caroline is looking forward to a date with her Husband, try to help her out."
  }
  
  Quest9 = {
    :ID => "9",
    :Name => "Where is my love?!",
    :QuestGiver => "Kindler",
    :Stage1 => "Go to the Cave",
    :Stage2 => "Go back to see if they're ok",
    :Location1 => "Granite Cave",
    :QuestDescription => "My girlfriend went into Granite Cave a few days ago and has never come back. Would you be willing to find her for me?",
    :RewardString => "Something Shiny!"
  }
  
  Quest10 = {
    :ID => "10",
    :Name => "A Sibling's Challenge",
    :QuestGiver => "Battle Girl",
    :Stage1 => "Battle and defeat him!",
    :Location1 => "Route 106",
    :QuestDescription => "Timmy dreams of becoming a Pokémon Trainer, but his lack of experience worries me. I need your help to give him a reality check.",
    :RewardString => "Something shiny!"
  }
  
  Quest11 = {
    :ID => "11",
    :Name => "Lotad, come home!",
    :QuestGiver => "Trainer",
    :Stage1 => "Find the Lotad!",
	:Location1 => "Somewhere on the island",
    :QuestDescription => "Help! My poor Lotad is somewhere on the island. Please help find him for me!",
    :RewardString => "nil"
  }
  
  Quest12 = {
    :ID => "12",
    :Name => "Wak in the Shadow",
    :QuestGiver => "Gal Goodgirl",
    :Stage1 => "Seek out cultist!",
    :Location1 => "Littleroot, Petalburg, Route 106",
    :QuestDescription => "Investigate the Enigmatic Cult: Uncover the secrets of the Marowak-worshipping cult that's been luring young females. They're believed to revere Marowak as a divine maternal figure. Unveil the truth, rescue the missing, and let justice prevail!",
    :RewardString => "Food, glorious food!"
 }

Quest13 = {
    :ID => "13",
    :Name => "Echoes of the Anchor: Enigmatic Domination",
    :QuestGiver => "Prof. Birch",
    :Stage1 => "Investigate the ship!",
    :Location1 => "Abandoned Ship",
    :QuestDescription => "There was suppose to be a new Professor visiting but her ship was attacked! Go to Mr.Briney and catch a ride there!",
    :RewardString => "Something shiny!"
 }
 
 Quest14 = {
    :ID => "14",
    :Name => "UwU to the OwO",
    :QuestGiver => "Gal Goodgirl",
    :Stage1 => "Stop whoever is infecting people!",
    :Location1 => "Petalburg woods",
    :QuestDescription => "Gal Goodgirl has come to you for help! There's some creature attacking People and infecting them with a horrible virus!",
    :RewardString => "Something shiny!"	
  }	
	
	Quest15 = {
    :ID => "15",
    :Name => "The Known Unknown? VS the Masquerading Champion",
    :QuestGiver => "Void Mudkip",
    :Stage1 => "Do your best!",
    :Location1 => "Granite Cave",
    :QuestDescription => "Void Mudpik has informed you of two powerful opponents. Kick their asses!",
    :RewardString => "Something shiny!"
  }
	
	Quest16 = {
    :ID => "16",
    :Name => "Vs the Pandemonic Planet",
    :QuestGiver => "Void Mudkip",
    :Stage1 => "Do your best!",
    :Location1 => "Route 3",
    :QuestDescription => "Void Mudpik has informed you of two powerful opponents. Kick their asses!!",
    :RewardString => "Something shiny!"
	
	}
	
	Quest17 = {
    :ID => "17",
    :Name => "Water Pokémon for the Shop",
    :QuestGiver => "Daisy",
    :Stage1 => "Catch a Wingull, Azurill, or Poliwag",
    :Location1 => ". . .",
    :QuestDescription => "The flower shop attendants are arguing over which Water Pokémon would best help water the plants. They ask you to catch a Wingull, Azurill, or Poliwag for them to use.",
    :RewardString => "A bundle of berries and mulch!"
}

    Quest18 = {
    :ID => "18",
    :Name => "Berry Restock Emergency",
    :QuestGiver => "Violet",
    :Stage1 => "Restock Violet’s berry stand",
    :Location1 => "Slateport City Market",
    :QuestDescription => "She needs your help to restock without the others finding out. 10 Oranberries, 5 Sitrusberries, 7 Pechaberries, 5 Cheriberries, and 3 Nullberries!",
    :RewardString => "A surprise gift from Violet!"
}

    Quest19 = {
    :ID => "19",
    :Name => "Bane of the Berries",
    :QuestGiver => "Daisy, Rose, and Violet",
    :Stage1 => "Investigate behind the shop",
    :Location1 => "Behind Pretty Petal Flower Shop",
    :Stage2 => "Defeat the Pokémon that's been eating the berries",
    :Location2 => "Pretty Petal Flower Shop",
    :QuestDescription => "A Pokémon has nested behind the shop and is eating all the berries. It looks like a Bug-type, but seems to resist Water-type attacks. Defeat it to help the girls out!",
    :RewardString => "A rare item and a bundle of berries"
}
    Quest20 = {
    :ID => "20",
    :Name => "Step into the Grand Tour",
    :QuestGiver => "Goddess",
    :Stage1 => "Check out the town",
    :Stage2 => "Challenge the Petalburg Gym",
    :Stage3 => "Complete Emotion known as rage",
    :Stage4 => "Challenge the Rustboro Gym",
    :Stage5 => "Complete Roxanne's request",
    :Stage6 => "Defeat the Rustboro Gym",
    :Stage7 => "Head to Mr. Briney's Home",
    :Stage8 => "Head to Granite Cave",
    :Stage9 => "Head to Ranger Guild",
    :Stage10 => "Talk to Lusamine",
    :Stage11 => "Talk to Gal Goodgirl",
    :Stage12 => "Head to Slateport City",
    :Stage13 => "Head to Oceanic Museum",
    :Stage14 => "Challenge the Mauville Gym",
	:Stage15 => "Talk to the girl near the desert",
	:Stage16 => "Head to Meteor Falls",
	:Stage17 => "Challenge the Lavaridge Gym",
	:Stage18 => "Head to Mt.Chimney",
	:Stage19 => "Challenge the Petalburg Gym",
	:Stage20 => "Complete Vs The Mistress of Apex",
	:Stage21 => "Check on Houndoom",
	:Stage22 => "Check on Inesse",
	:Stage23 => "Complete Usurping the Apex",
	:Stage24 => "Working on it!",
    :Location1 => "Littleroot Town",
    :Location2 => "Petalburg Gym",
    :Location3 => "Petalburg Gym",
    :Location4 => "Rustboro City",
    :Location5 => "Trainer school",
    :Location6 => "Rustboro Gym",
    :Location7 => "Route 104",
    :Location8 => "Route 106",
    :Location9 => "Dewford Town",
    :Location10 => "Rustboro City",
    :Location11 => "Rustboro City",
    :Location12 => "Mr. Briney's Home",
    :Location13 => "Slateport City",
    :Location14 => "Mauville Gym",
	:Location15 => "Route 111",
	:Location16 => "Meteor Falls",
	:Location17 => "Lavaridge Gym",
	:Location18 => "Mt.Chimney",
	:Location19 => "Petalburg Gym",
	:Location20 => "Mt.Chimney",
	:Location21 => "Home",
	:Location22 => "Rustboro",
	:Location23 => "Route 110",
	:Location24 => "Working on it!",
	:QuestDescription => "The Goddess has set you on your epic journey, this is an outline of things to do to achieve your goal. Step into the grand tour! Note: If you get lost, try fighting a gym or something.",
    :RewardString => "The journey itself!"
	
}

    Quest21 = {
    :ID => "21",
    :Name => "Roxanne's request",
    :QuestGiver => "Roxanne",
    :Stage1 => "Retrieve Fossils",
    :Location1 => "Harrow Cave",
    :QuestDescription => "The Gym Leader Roxanne has decided to task you with getting fossils for her! Retrieve them then head back the the Trainer School.",
    :RewardString => "A Gym Challenge"
	
}

    Quest22 = {
    :ID => "22",
    :Name => "Fossil Expedition",
    :QuestGiver => "May",
    :Stage1 => "Retrieve a Root fossil for May",
    :Location1 => "Harrow Cave",
    :QuestDescription => "May is helping her father with research and needs you to find a fossil from a cave near Route 116.",
    :RewardString => "A rare item from May!"
}

    Quest23 = {
    :ID => "23",
    :Name => "May's Favorite Treat",
    :QuestGiver => "May",
    :Stage1 => "Get May a Big Malasada",
    :Location1 => "Slateport City",
    :QuestDescription => "May has been craving her favorite food, a Big Malasada, and asks you to bring her one from Slateport City.",
    :RewardString => "A special item from May!"
}

    Quest24 = {
    :ID => "24",
    :Name => "For research purposes",
    :QuestGiver => "May",
    :Stage1 => "Show May a Skitty",
    :Location1 => "Route 116",
    :QuestDescription => "May is conducting research on Pokémon species and requests a Skitty for study. Catch one and show it to her.",
    :RewardString => "A special gift from May!"

}

    Quest25 = {
    :ID => "25",
    :Name => "Defend the Ghost Pokémon",
    :QuestGiver => "Hexy",
    :Stage1 => "Defeat 5 Murkrow in Petalburg Woods",
    :Location1 => "Petalburg Woods",
    :QuestDescription => "A Hex Maniac in Petalburg Woods asks you to defeat 5 Murkrow that are attacking Ghost Pokémon.",
    :RewardString => "A protective item from the Hex Maniac."
}

    Quest26 = {
    :ID => "26",
    :Name => "A Fanfiction Feud",
    :QuestGiver => "Hex Maniac",
    :Stage1 => "Defeat the hater",
    :Location1 => "Rustboro City",
    :QuestDescription => "The Hex Maniac asks you to battle and defeat a girl who has been downvoting her fanfiction online. She's near the entrance of Rustboro . ..  and she has a HAT!",
    :RewardString => "A gift from the Hex Maniac."
}
    Quest27 = {
    :ID => "27",
    :Name => "A Normal Day",
    :QuestGiver => "Hex Maniac",
    :Stage1 => "Buy a Floral Dress",
    :Location1 => "Slateport Market",
    :QuestDescription => "The Hex Maniac’s parents have threatened to cut off her financial support unless she spends a day in 'normal' clothes. Help her find an outfit that makes her look normal.",
    :RewardString => "A gift from the Hex Maniac."
}
    Quest28 = {
    :ID => "28",
    :Name => "Knot of Destiny",
    :QuestGiver => "Hex Maniac",
    :Stage1 => "Find a Destiny Knot",
    :Location1 => "Slateport City",
    :QuestDescription => "The Hex Maniac is working on a ritual doll and needs a Destiny Knot to complete it. Find one for her.",
    :RewardString => "A strange gift from the Hex Maniac."
}
    Quest29 = {
    :ID => "29",
    :Name => "Sibling Rivalry",
    :QuestGiver => "Hex Maniac",
    :Stage1 => "Defeat Hexy's sister",
    :Location1 => "Petalburg Woods",
    :QuestDescription => "Hexy's sister has been saying you're weak. Prove her wrong by defeating her in a battle.",
    :RewardString => "A special reward from Hex Maniac."
}
    Quest30 = {
    :ID => "30",
    :Name => "Vengeful Spirits of the Sea",
    :QuestGiver => "Hex Maniac",
    :Stage1 => "Catch a Basculegion",
    :Location1 => "Trackless Forest",
    :QuestDescription => "Hex Maniac’s Ghost-type team is vulnerable to Fire-type Pokémon. She believes a Basculegion will help balance her team’s power.",
    :RewardString => "Stuff!"
}
    Quest31 = {
    :ID => "31",
    :Name => "May’s New Look",
    :QuestGiver => "May",
    :Stage1 => "Surprise May by buying her a new outfit",
    :Location1 => "Slateport Market",
    :QuestDescription => "May is upset because the outfit she bought doesn’t fit, and she doesn’t have enough money for a new one. Surprise her by buying a replacement without her knowing.",
    :RewardString => "Heart Scale or Battle Item"
}
    Quest32 = {
   :ID => "32",
   :Name => "Morpeko for Research",
   :QuestGiver => "May",
   :Stage1 => "Catch a Morpeko",
   :Location1 => "Route 110",
   :QuestDescription => "Professor Birch is excited to research the newly found Electric-type Pokémon, Morpeko. May needs your help to catch one for him.",
   :RewardString => "Thunder Stone or Electric-type Battle Item"
}
    Quest33 = {
    :ID => "33",
    :Name => "Big Malasada Date",
    :QuestGiver => "May",
    :Stage1 => "Head to the Slateport Market",
    :Stage2 => "Defeat the thugs harassing the stand owner",
    :Location1 => "Slateport City Market",
    :QuestDescription => "May wants to go out for Big Malasadas with you, but when you arrive at the stand, thugs are causing trouble. Defeat them and enjoy your date.",
    :RewardString => "Big Malasadas and a great time with May!"
}
    Quest34 = {
    :ID => "34",
    :Name => "Johanna’s Pokéblock Recipe",
    :QuestGiver => "Johanna",
    :Stage1 => "Gather the berries for Johanna",
    :Location1 => "Check route 104",
    :QuestDescription => "Johanna is missing the berries she needs to make a special batch of Pokéblocks for an upcoming contest. Help her gather the berries to finish her recipe. 5 Razz Berries, 3 Bluk Berries, 2 Pamtre Berries",
    :RewardString => "Something Awesome!"
}
    Quest35 = {
    :ID => "35",
    :Name => "Johanna’s Sweet Craving",
    :QuestGiver => "Johanna",
    :Stage1 => "Collect 3 Sweet Candies",
    :Location1 => "PokeMart",
    :QuestDescription => "Johanna has a sudden craving for candy and asks you to bring her some Sweet Candies to satisfy her sweet tooth.",
    :RewardString => "Something Awesome!"
}
    Quest36 = {
    :ID => "36",
    :Name => "Sew It Begins",
    :QuestGiver => "Johanna",
    :Stage1 => "Catch a Beautifly.",
    :Location1 => "",
    :QuestDescription => "Johanna is trying to make contest outfits for her students, but she needs silk from a Beautifly to complete them. Help her by catching one!",
    :RewardString => "Something Awesome!"
}
    Quest37 = {
    :ID => "37",
    :Name => "Purrfect Remedy",
    :QuestGiver => "Johanna",
    :Stage1 => "Buy Medical Root",
    :Location1 => "Slateport City Market",
    :QuestDescription => "Johanna’s Glameow is under the weather, and she needs Medical Root from Slateport City to help. Deliver them quickly!",
    :RewardString => "Glameow's Charm"
}
    Quest38 = {
    :ID => "38",
    :Name => "The Doll Dilemma",
    :QuestGiver => "Johanna",
    :Stage1 => "Visit Gard E.Voir",
    :Location1 => "Oldale Town",
    :QuestDescription => "Johanna had a special doll commissioned, but the doll maker hasn’t finished it or refunded her money. Visit Gard E.Voir in Odale Town and settle the matter.",
    :RewardString => "Something Awesome"
}
    Quest39 = {
    :ID => "39",
    :Name => "Mega Evolution Motivation",
    :QuestGiver => "Johanna",
    :Stage1 => "Find a Kangaskhanite.",
    :Location1 => "Verdanturf Town",
    :QuestDescription => "Johanna has been training her Pokémon again, and she feels ready to take on the challenge of Mega Evolution. Help her find a Kangaskhanite so she can Mega Evolve her Kangaskhan.",
    :RewardString => "Something Awesome"
}
    Quest40 = {
    :ID => "40",
    :Name => "A Mother’s Worry",
    :QuestGiver => "Johanna",
    :Stage1 => "Deliver a package to Dawn",
    :Location1 => "Verdanturf",
    :QuestDescription => "Johanna has a special package she needs delivered to her daughter, Dawn, who has been working hard and hasn’t been in touch as much as usual. Johanna wants to make sure Dawn gets the supplies she needs but doesn't want her to know that they came from her.",
    :RewardString => "A heartfelt gift from Johanna and a Token of Gratitude"
}
    Quest41 = {
    :ID => "41",
    :Name => "Sign of Love: Lapras",
    :QuestGiver => "Lapras",
    :Stage1 => "Increase her Affinity",
    :Location1 => "...",
    :QuestDescription => "Lapras seems to have taken a liking to you! It would be best to show her some loving! Big Pearl, 5 Chesto Berries, Sea Incense, SlowPoke Tail, Heart Scale, Water Gem",
    :RewardString => ". . ."
}
    Quest42 = {
    :ID => "42",
    :Name => "Sign of Love: Machoke",
    :QuestGiver => "Machoke",
    :Stage1 => "Increase her Affinity",
    :Location1 => "...",
    :QuestDescription => "Machoke seems to have taken a liking to you! It would be best to show her some loving! Protein, Muscle Band, Power Belt, Pewter Crunchies, Energy Powder, Fighting Gem",
    :RewardString => ". . ."
}
    Quest43 = {
    :ID => "43",
    :Name => "Vs. The Evil MagiPoke Shojo",
    :QuestGiver => "Voidkip",
    :Stage1 => "Defeat them!",
    :Location1 => "Trackless Forest",
    :QuestDescription => "Voidkip has informed you that Braixen is feeling the presence of a powerful Evil MagiPoke Shojo. You still don't get any of this because you're not a weeb. However, like all tasks, it's your job to handle it.",
    :RewardString => ". . ."
}
    Quest44 = {
    :ID => "44",
    :Name => "A Fishy Duel",
    :QuestGiver => "Lana",
    :Stage1 => "Speak to Lana",
    :Stage2 => "Battle Lana to claim her rare Feebas.",
    :Stage3 => "Win the battle and receive the Feebas as a reward.",
    :Location1 => "Route 109",
    :QuestDescription => "Lana has something she wants to show you.",
    :RewardString => ". . ."
}
    Quest45 = {
    :ID => "45",
    :Name => "Sign of Love: Feebas",
    :QuestGiver => "Feebas",
    :Stage1 => "Increase her Affinity",
    :Location1 => "...",
    :QuestDescription => "Feebas seems to have taken a liking to you! It would be best to show her some loving! Big Pearl, 5 Chesto Berries, Sea Incense, Slowpoke Tail, Heart Scale, Water Gem",
    :RewardString => ". . ."
}
    Quest46 = {
    :ID => "46",
    :Name => "Sign of Love: Sneasel",
    :QuestGiver => "Sneasel",
    :Stage1 => "Increase her Affinity",
    :Location1 => "...",
    :QuestDescription => "Sneasel seems to have taken a liking to you! It would be best to show her some loving! Carbos, Swift Feather, Power Anklet, Casteliacone, Adamant Mint, Dark Gem",
    :RewardString => ". . ."
}
    Quest47 = {
    :ID => "47",
    :Name => "The Legendary Fisherman!",
    :QuestGiver => "Nami",
    :Stage1 => "Fish for Pokemon!",
    :Location1 => "Fishing around the Region",
    :QuestDescription => "Nami's shop is about to go under! She needs you to become the Legendary fisher! Try catching a Magikarp, Barboach, Goldeen, Tentacool, Feebas, Luvdisc, Carvanha, Basculin, and Remoraid and give them to her!",
    :RewardString => ". . ."
}
    Quest48 = {
    :ID => "48",
    :Name => "This is an adventure, Right?",
    :QuestGiver => "Johanna",
    :Stage1 => "Track down Dawn!",
    :Location1 => "Trackless Forest",
    :QuestDescription => "Dawn has gone silent and Johanna is worried! Last they spoke Dawn talked about taking on the Lost Woods, with Johanna in tow take on the forest and find Dawn.",
    :RewardString => "A heartfelt gift from Johanna and a Token of Gratitude"
}
    Nami1 = {
    :ID => "49",
    :Name => "Fin & Punishment!",
    :QuestGiver => "Nami",
    :Stage1 => "Seek out Gal",
	:Stage2 => "Met up with Goons",
	:Stage3 => "Head to Don's hideout",
	:Stage4 => "Head to Nami",
    :Location1 => "Rustboro City",
	:Location2 => "Route 107",
	:Location3 => "Route 115 (Meteor Falls)",
	:Location4 => "Route 109",
    :QuestDescription => "Nami is being extorted by Don Poleon, and you to defeat them!",
    :RewardString => "A heartfelt gift from Nami and a Token of Gratitude"
}
	
  # Rookidee Side-Quest
  # Post Gym 2
  Arcanine = {
    :ID => "109",
    :Name => "Birds of a Feather",
    :QuestGiver => "Hugh",
    :Stage1 => "Check out the Den on Route 116",
    :Location1 => "Route 116",
    :QuestDescription => "You were informed about a powerful Pokémon living somewhere on Route 116!",
    :RewardString => "A Pokémon."
	
}
    Wool = {
    :ID => "50",
    :Name => "Birds of a Feather",
    :QuestGiver => "Rosa",
    :Stage1 => "Check out the Wool-Con?",
    :Location1 => "Fiery Connection",
    :QuestDescription => "Rosa informed you that some Wooly Pokemon are bullying others, check it out!",
    :RewardString => "Glory and stuff!"
	
}
    Abomineon = {
    :ID => "51",
    :Name => "Entity Case files NO.1",
    :QuestGiver => "Voidkip",
    :Stage1 => "Investigate the Weather institute?",
    :Location1 => "Weather institute?",
    :QuestDescription => "After battling with an monsterous creature that injured Wally, you are tasked with pursuring and making sure it doesn't harm anyone else!",
    :RewardString => "Glory and stuff!"
	
}

    Wicke1 = {
    :ID => "52",
    :Name => "Shadow of the sea",
    :QuestGiver => "Wicke",
    :Stage1 => "Take down the Shadow Stalker!",
    :Location1 => "Abandoned Ship!",
    :QuestDescription => "Wicke detected a strange energy source, but others were driven back by a mist-shrouded Pokémon.",
    :RewardString => "Glory and stuff!"

}

    SmeargleBerryQuest1 = {
    :ID => "53",
    :Name => "Berry Bundle for the Club",
    :QuestGiver => "Grace",
    :Stage1 => "Pick up the special berry bundle!",
    :Location1 => "Pretty Petal Flower Shop",
    :QuestDescription => "Grace, the new Chairwoman of the Slateport Pokémon Fan Club, has commissioned a special berry bundle to inspire the club's artistic vibe. Pick it up from the Pretty Petal Flower Shop.",
    :RewardString => "Club gratitude and a rare berry!"
	
}

    SmeargleArtContestQuest = {
    :ID => "54",
    :Name => "Pokémon Art Contest Judge",
    :QuestGiver => "Grace",
    :Stage1 => "Recruit Captain Stern to judge!",
	:Stage2 => "Help Stern Retrieve his Prototype!",
	:Stage2 => "Return to Stern!",
    :Location1 => "Slateport Shipyard",
	:Location2 => "Route 103",
	:Location3 => "Slateport Shipyard",
    :QuestDescription => "The Chairwoman of the Slateport Pokémon Fan Club is hosting a Pokémon Art Contest to celebrate creative Pokémon. She needs a notable judge and suggests Captain Stern, a local celebrity. Convince him at the Slateport Shipyard to join the event.",
    :RewardString => "Club prestige and an artistic gift!"

}

    SmeargleHatennaQuest = {
    :ID => "55",
    :Name => "Find Hatenna",
    :QuestGiver => "Grace",
    :Stage1 => "Search for Hatenna on Route 111!",
    :Stage2 => "Check out the Oceanic Museum!",
    :Location1 => "Route 111",
    :Location2 => "Oceanic Museum",
    :QuestDescription => "Grace has planned a grand exhibit at the museum, but Hatenna has run away. Grace's mention of a 'Plan B' seems suspicious. Search Route 110 for clues to find Hatenna before attending the exhibit.",
    :RewardString => "Hatenna's gratitude and a mysterious item!"
  
}

    WallyGrowthQuest = {
    :ID => "56",
    :Name => "Wally's Will",
    :QuestGiver => "Wally",
    :Stage1 => "Investigate the wild Pokémon!",
    :Location1 => "Route 117",
    :QuestDescription => "A group of wild Pokémon are injuring people. Head to Route 117 to confront the wild Pokémon and protect the town.",
    :RewardString => "Wally’s gratitude and a special item!"
}

   QuestLass = {
    :ID => "57",
    :Name => "A Lass’s Lost Ribbon",
    :QuestGiver => "Lass",
    :Stage1 => "Find the lost ribbon.",
    :Stage2 => "Return the ribbon to the Lass.",
    :Location1 => "Route 102",
    :QuestDescription => "A Lass on Route 102 lost her pink ribbon while playing with her Zigzagoon. Search the tall grass for it and return it to her.",
    :RewardString => "Potion ×3 or Oran Berry ×5"
}
   QuestLady = {
    :ID => "58",
    :Name => "Pearls and Panic",
    :QuestGiver => "Lady Cindy",
    :Stage1 => "Investigate the commotion on the beach.",
    :Stage2 => "Defeat the aggressive Pokémon.",
    :Stage3 => "Report back to Lady Cindy.",
    :Location1 => "Route 104 Beach",
    :QuestDescription => "Lady Cindy is in hysterics! Something is smashing picnic baskets and scaring people on the Route 104 beach. Go calm the scene and stop the rampaging Pokémon.",
    :RewardString => "Nugget or Pearl"
}
   QuestBugCatcher = {
    :ID => "59",
    :Name => "Stings and Wings",
    :QuestGiver => "Bug Catcher",
    :Stage1 => "Protect the cocoons from the attackers.",
    :Stage2 => "Report back to the Bug Catcher.",
    :Location1 => "Petalburg Woods",
    :QuestDescription => "A Bug Catcher in Petalburg Woods begs for help! Something keeps dive-bombing a cluster of cocoons at a forest hollow. Go there, drive off the attackers, and make sure the cocoons are safe.",
    :RewardString => "SilverPowder or Net Ball ×2"
}

   SternsProtoype = {
    :ID => "60",
    :Name => "Stern’s Stolen Prototype",
    :QuestGiver => "Gal Goodgirl",
    :Stage1 => "Speak with Captain Stern at the Shipyard.",
    :Stage2 => "Retrieve Stern’s stolen prototype.",
    :Stage3 => "Return the prototype to Stern.",
    :Location1 => "Slateport Beach",
    :Location2 => "Route 103",
    :Location3 => "Slateport Shipyard",
    :QuestDescription => "Gal Goodgirl mentioned that Captain Stern needs help recovering a valuable prototype stolen from the Slateport Shipyard. Track down the culprit and return the missing item to him.",
    :RewardString => "Captain Stern’s gratitude and a rare mechanical part!"
}
    
   LusamineCaveQuest = {
    :ID => "61",
    :Name => "Project Awakening",
    :QuestGiver => "Lusamine",
    :Stage1 => "Escort Lusamine to the Dewford research site.",
    :Location1 => "Dewford Cave",
    :QuestDescription => "Lusamine confides in you about a confidential research operation near Dewford.",
    :RewardString => "Lusamine’s approval."
}	
   LillieCaveQuest = {
    :ID => "62",
    :Name => "The First Signs",
    :QuestGiver => "Lillie",
    :Stage1 => "Investigate the Dewford cave with Lillie.",
    :Location1 => "Dewford Cave",
    :QuestDescription => "Lillie has discovered her mother is secretly researching strange energies beneath Dewford.",
    :RewardString => "Lillie's trust and a lead on Lusamine's secret project."
}

   LilthBlackBeltQuest = {
    :ID => "63",
    :Name => "Power in Cloth",
    :QuestGiver => "Lilth",
    :Stage1 => "Find a Black Belt",
    :Location1 => "Dewford Island",
    :QuestDescription => "Lilth wants to power up her own Pokémon. She asks you to find a Black Belt she can use to help her partner grow.",
    :RewardString => "Lilth’s gratitude!"
}

   LilthMuscleBandQuest = {
    :ID => "64",
    :Name => "Toning the Muscles",
    :QuestGiver => "Lilth",
    :Stage1 => "Find a Muscle Band.",
    :Location1 => "Dewford Island",
    :QuestDescription => "Lilth wants to improve her Pokémon's striking power. She asks you to find a Muscle Band for her intense training sessions.",
    :RewardString => "Lilth’s thanks."
}

   LilthShowFightingQuest = {
    :ID => "65",
    :Name => "Show Me Power",
    :QuestGiver => "Lilth",
    :Stage1 => "Give Lilth a Machamp.",
    :Location1 => "Dewford Island",
    :QuestDescription => "Inspired by your victories, Lilth wants to own a strong Fighting-type Pokémon you’ve trained. Bring one to her to motivate her own training.",
    :RewardString => "Lilth’s respect and top-tier training gear."
}

   Quest66 = {
    :ID => "66",
    :Name => "Sign of Love: Greninja",
    :QuestGiver => "Greninja",
    :Stage1 => "Increase her Affinity",
    :Location1 => "...",
    :QuestDescription => "Greninja seems to have taken a liking to you! It would be best to show her some loving! Big Pearl, 5 Chesto Berries, Sea Incense, Slowpoke Tail, Heart Scale, Water Gem",
    :RewardString => ". . ."
	
}

    Quest67 = {
    :ID => "67",
    :Name => "Sign of Love: Goodra",
    :QuestGiver => "Goodra",
    :Stage1 => "Increase her Affinity",
    :Location1 => "...",
    :QuestDescription => "Goodra seems to have taken a liking to you! It would be best to show her some loving! Protein, Muscle Band, Power Belt, Pewter Crunchies, Energy Powder, Dragon Gem",
    :RewardString => ". . ."
	
}

    WickeHurtPokemonQuest = {
    :ID => "68",
    :Name => "A Pokémon in Distress",
    :QuestGiver => "Wicke",
    :Stage1 => "Help Wicke examine a Pokémon wounded by an aggressive attacker.",
    :Location1 => "Route 113",
    :QuestDescription => "Wicke found an injured Pokémon that was attacked by an unusually aggressive wild Pokémon. Handle the threat!",
    :RewardString => "Stuff!"
	
}

    WickeRescueQuest = {
    :ID => "69",
    :Name => "Operation: Aether Rescue",
    :QuestGiver => "Wicke",
    :Stage1 => "Help Wicke recover Pokémon stolen by Team Rocket.",
    :Location1 => "Route 110",
    :QuestDescription => "Wicke discovered that Team Rocket has stolen endangered Pokémon! Kick their ass!",
    :RewardString => "Stuff!"
}


    WickeGoldenScaleQuest = {
    :ID => "70",
    :Name => "The Golden Scale",
    :QuestGiver => "Wicke",
    :Stage1 => "Find a Golden Scale for Wicke.",
    :Location1 => "Any Waterside Location",
    :QuestDescription => "Wicke is researching a rare phenomenon involving shimmering golden scales that appear near Hoenn’s waters. She needs your help retrieving one for analysis.",
    :RewardString => "Aether-grade research supplies and Wicke’s affection."
	
}

    Quest71 = {
    :ID => "71",
    :Name => "Sign of Love: Maractus",
    :QuestGiver => "Maractus",
    :Stage1 => "Increase her Affinity",
    :Location1 => "...",
    :QuestDescription => "Maractus seems to have taken a liking to you! It would be best to show her some loving! Energy Root, 5 Lum Berries, Rose Incense, Sticky Barbs, TM37, Grass Gem",
    :RewardString => ". . ."
	
 }
 
    Quest72 = {
    :ID => "72",
    :Name => "Sign of Love: Flygon",
    :QuestGiver => "Flygon",
    :Stage1 => "Increase her Affinity",
    :Location1 => "...",
    :QuestDescription => "Flygon seems to have taken a liking to you! It would be best to show her some loving! Big Pearl, 5 Chesto Berries, Draco Plate, Pewter Crunchies, Heart Scale, Dragon Gem",
    :RewardString => ". . ."
	
 }
 
   Quest73 = {
    :ID => "73",
    :Name => "Sign of Love: Houndoom",
    :QuestGiver => "Houndoom",
    :Stage1 => "Increase her Affinity",
    :Location1 => "...",
    :QuestDescription => "Houndoom seems to have taken a liking to you! It would be best to show her some loving! Big Pearl, 5 Chesto Berries, Flame Plate, Pewter Crunchies, Heart Scale, Fire Gem",
    :RewardString => ". . ." 
 
  }
 
   Houndoom1 = {
    :ID => "74",
    :Name => "Rebel Howl",
    :QuestGiver => "Houndoom",
    :Stage1 => "See what she wants",
    :Location1 => "Mt. Chimney",
    :QuestDescription => "Houndoom seems to want you to follow her to Mt. Chimney so something.",
    :RewardString => ". . ." 
	
   }
  #======================================================#
  #                                                      #
  #                      "Official"                      #
  #                      Sidequests                      #
  #             Thanks, MDH! I had a blast <3            #
  #                                                      #
  #======================================================#

  # Luxio Sidequest
  # Mauville Ranger Guild Lobby. 
  # Prereq: Defeated Gym 3
  Luxio = {
    :ID => "110",
    :Name => "(Old) New Mauville",
    :QuestGiver => "Wattson",
    :Stage1 => "Turn off the Odd Generator",
    :Stage2 => "Return to New Mauville",
    :Location1 => "New Mauville",
    :Location2 => "New Mauville",
    :QuestDescription => "Something is overclocking the Odd Generator - turn it off!",
    :RewardString => "Wattson's gratitude."
	}

  # Zoe Quest
  # Mauville Ranger Guild, Lobby.
  # Prereq: (Old) New Mauville 
  Zoe = {
    :ID => "115",
    :Name => "Thank you for being a Pal",
    :QuestGiver => "Wattson",
    :Stage1 => "Investigate New Mauville again",
    :Location1 => "New Mauville",
    :QuestDescription => "Something detonated inside of New Mauville - and it wasn't just a Voltorb.",
    :RewardString => "You wouldn't just do this for Wattson? Shame on you."
	}

  # Lapras Sidequest
  # Ranger Guild Board
  # Prereq: Beaten Shelly & Courtney in Meteor Falls 
  Lapras = {
    :ID => "111",
    :Name => "Storm's a'Brewin",
    :QuestGiver => "Mr. Briney",
    :Stage1 => "Figure out what's happening on Route 105.",
    :Location1 => "Dewford Town",
    :QuestDescription => "Something is causing ocean surges on Route 105...",
    :RewardString => "Shells"
	}

  # Vulpix Sidequest
  # Mauville Ranger Guild, B1
  # No Requirements
  Vulpix = {
    :ID => "112",
    :Name => "Hi! Alola!",
    :QuestGiver => "PKMN Breeder",
    :Stage1 => "Find the breeder's lost Pokémon!",
    :Location1 => "Route 110",
    :QuestDescription => "A foreign PKMN Breeder lost a pair of Vulpix!",
    :RewardString => "Somethings Shiny!"
	}

  # Sneasel Sidequest
  # Ranger Guild Board
  # > 15,000 Coins
  Sneasel = {
    :ID => "113",
    :Name => "Better Have My Money",
    :QuestGiver => "Guild Board",
    :Stage1 => "Help the Mauville Game Corner!",
    :Location1 => "Mauville City",
    :QuestDescription => "The Game Corner reported something suspicious...",
    :RewardString => "Coins! Hopefully, anyway."
	}

  # Machoke Sidequest
  # Ranger Guild Board
  # Was originally gonna be @ Lavaridge Ranger Guild, but...
  Machoke = {
    :ID => "114",
    :Name => "Monday Night RAW",
    :QuestGiver => "Guild Board",
    :Stage1 => "Head to the Jagged Pass",
    :Location1 => "Jagged Pass",
    :QuestDescription => "From what you can gather, something has gone wrong.",
    :RewardString => "The heavyweight championship."
	}
  
end
