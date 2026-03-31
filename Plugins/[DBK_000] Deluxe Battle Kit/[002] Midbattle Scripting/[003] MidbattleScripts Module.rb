#===============================================================================
# Midbattle Scripts
#===============================================================================
# This module stores all custom battle scripts that can be called upon with the
# battle rule "midbattleScript" if you don't want to input the entire script in
# the event script itself, due to it being too long or if you just find it neater
# this way.
#
# Note that when calling one of the scripts here, you do so in the event by
# setting the constant you defined here as a battle rule.
#
# 	For example:  
#   setBattleRule("midbattleScript", :DEMO_SPEECH)
#
#   *Note that a semi-colon is required in front of the constant when called, 
#    but not when defined below.
#-------------------------------------------------------------------------------
module MidbattleScripts
  #-----------------------------------------------------------------------------
  # Demo for displaying each of the main triggers and when they activate.
  #-----------------------------------------------------------------------------
  DEMO_SPEECH = {
    "RoundStartCommand_foe" => "Trigger: 'RoundStartCommand'\n({2}, {1})",
    "RoundStartAttack_foe"  => "Trigger: 'RoundStartAttack'\n({2}, {1})",
    "RoundEnd_foe"          => "Trigger: 'RoundEnd'\n({2}, {1})",
    "TurnStart_foe"         => "Trigger: 'TurnStart'\n({2}, {1})",
    "TurnEnd_foe"           => "Trigger: 'TurnEnd'\n({2}, {1})",
    "BeforeItemUse"         => "Trigger: 'BeforeItemUse'\n({2}, {1})",
    "AfterItemUse"          => "Trigger: 'AfterItemUse'\n({2}, {1})",
    "BeforeCapture"         => "Trigger: 'BeforeCapture'\n({2}, {1})",
    "AfterCapture"          => "Trigger: 'AfterCapture'\n({2}, {1})",
    "FailedCapture"         => "Trigger: 'FailedCapture'\n({2}, {1})",
    "BeforeSwitchOut"       => "Trigger: 'BeforeSwitchOut'\n({2}, {1})",
    "BeforeSwitchIn"        => "Trigger: 'BeforeSwitchIn'\n({2}, {1})",
    "BeforeLastSwitchIn"    => "Trigger: 'BeforeLastSwitchIn'\n({2}, {1})",
    "AfterSwitchIn"         => "Trigger: 'AfterSwitchIn'\n({2}, {1})",
    "AfterLastSwitchIn"     => "Trigger: 'AfterLastSwitchIn'\n({2}, {1})",
    "AfterSendOut"          => "Trigger: 'AfterSendOut'\n({2}, {1})",
    "AfterLastSendOut"      => "Trigger: 'AfterLastSendOut'\n({2}, {1})",
    "BeforeMegaEvolution"   => "Trigger: 'BeforeMegaEvolution'\n({2}, {1})",
    "AfterMegaEvolution"    => "Trigger: 'AfterMegaEvolution'\n({2}, {1})",
    "BeforePrimalReversion" => "Trigger: 'BeforePrimalReversion'\n({2}, {1})",
    "AfterPrimalReversion"  => "Trigger: 'AfterPrimalReversion'\n({2}, {1})",
    "BeforeMove"            => "Trigger: 'BeforeMove'\n({2}, {1})",
    "BeforeDamagingMove"    => "Trigger: 'BeforeDamagingMove'\n({2}, {1})",
    "BeforePhysicalMove"    => "Trigger: 'BeforePhysicalMove'\n({2}, {1})",
    "BeforeSpecialMove"     => "Trigger: 'BeforeSpecialMove'\n({2}, {1})",
    "BeforeStatusMove"      => "Trigger: 'BeforeStatusMove'\n({2}, {1})",
    "AfterMove"             => "Trigger: 'AfterMove'\n({2}, {1})",
    "AfterDamagingMove"     => "Trigger: 'AfterDamagingMove'\n({2}, {1})",
    "AfterPhysicalMove"     => "Trigger: 'AfterPhysicalMove'\n({2}, {1})",
    "AfterSpecialMove"      => "Trigger: 'AfterSpecialMove'\n({2}, {1})",
    "AfterStatusMove"       => "Trigger: 'AfterStatusMove'\n({2}, {1})",
    "UserDealtDamage"       => "Trigger: 'UserDealtDamage'\n({2}, {1})",
    "UserDamagedSub"        => "Trigger: 'UserDamagedSub'\n({2}, {1})",
    "UserBrokeSub"          => "Trigger: 'UserBrokeSub'\n({2}, {1})",
    "UserDealtCriticalHit"  => "Trigger: 'UserDealtCriticalHit'\n({2}, {1})",
    "UserMoveEffective"     => "Trigger: 'UserMoveEffective'\n({2}, {1})",
    "UserMoveResisted"      => "Trigger: 'UserMoveResisted'\n({2}, {1})",
    "UserMoveNegated"       => "Trigger: 'UserMoveNegated'\n({2}, {1})",
    "UserMoveDodged"        => "Trigger: 'UserMoveDodged'\n({2}, {1})",
    "UserHPHalf"            => "Trigger: 'UserHPHalf'\n({2}, {1})",
    "UserHPLow"             => "Trigger: 'UserHPLow'\n({2}, {1})",
    "LastUserHPHalf"        => "Trigger: 'LastUserHPHalf'\n({2}, {1})",
    "LastUserHPLow"         => "Trigger: 'LastUserHPLow'\n({2}, {1})",
    "TargetTookDamage"      => "Trigger: 'TargetTookDamage'\n({2}, {1})",
    "TargetSubDamaged"      => "Trigger: 'TargetSubDamaged'\n({2}, {1})",
    "TargetSubBroken"       => "Trigger: 'TargetSubBroken'\n({2}, {1})",
    "TargetTookCriticalHit" => "Trigger: 'TargetTookCriticalHit'\n({2}, {1})",
    "TargetWeakToMove"      => "Trigger: 'TargetWeakToMove'\n({2}, {1})",
    "TargetResistedMove"    => "Trigger: 'TargetResistedMove'\n({2}, {1})",
    "TargetNegatedMove"     => "Trigger: 'TargetNegatedMove'\n({2}, {1})",
    "TargetDodgedMove"      => "Trigger: 'TargetDodgedMove'\n({2}, {1})",
    "TargetHPHalf"          => "Trigger: 'TargetHPHalf'\n({2}, {1})",
    "TargetHPLow"           => "Trigger: 'TargetHPLow'\n({2}, {1})",
    "LastTargetHPHalf"      => "Trigger: 'LastTargetHPHalf'\n({2}, {1})",
    "LastTargetHPLow"       => "Trigger: 'LastTargetHPLow'\n({2}, {1})",
    "BattlerFainted"        => "Trigger: 'BattlerFainted'\n({2}, {1})",
    "LastBattlerFainted"    => "Trigger: 'LastBattlerFainted'\n({2}, {1})",
    "BattlerReachedHPCap"   => "Trigger: 'BattlerReachedHPCap'\n({2}, {1})",
    "BattlerHPRecovered"    => "Trigger: 'BattlerHPRecovered'\n({2}, {1})",
    "BattlerHPFull"         => "Trigger: 'BattlerHPFull'\n({2}, {1})",
    "BattlerHPReduced"      => "Trigger: 'BattlerHPReduced'\n({2}, {1})",
    "BattlerHPCritical"     => "Trigger: 'BattlerHPCritical'\n({2}, {1})",
    "BattlerStatusChange"   => "Trigger: 'BattlerStatusChange'\n({2}, {1})",
    "BattlerStatRaised"     => "Trigger: 'BattlerStatRaised'\n({2}, {1})",
    "BattlerStatLowered"    => "Trigger: 'BattlerStatLowered'\n({2}, {1})",
    "BattlerMoveZeroPP"     => "Trigger: 'BattlerMoveZeroPP'\n({2}, {1})",
    "WeatherEnded"          => "Trigger: 'WeatherEnded'\n({2}, {1})",
    "TerrainEnded"          => "Trigger: 'TerrainEnded'\n({2}, {1})",
    "FieldEffectEnded"      => "Trigger: 'FieldEffectEnded'\n({2}, {1})",
    "TeamEffectEnded"       => "Trigger: 'TeamEffectEnded'\n({2}, {1})",
    "BattlerEffectEnded"    => "Trigger: 'BattlerEffectEnded'\n({2}, {1})",
    "BattleEnd"             => "Trigger: 'BattleEnd'\n({2}, {1})",
    "BattleEndWin"          => "Trigger: 'BattleEndWin'\n({2}, {1})",
    "BattleEndLoss"         => "Trigger: 'BattleEndLoss'\n({2}, {1})",
    "BattleEndDraw"         => "Trigger: 'BattleEndDraw'\n({2}, {1})",
    "BattleEndForfeit"      => "Trigger: 'BattleEndForfeit'\n({2}, {1})",
    "BattleEndRun"          => "Trigger: 'BattleEndRun'\n({2}, {1})",
    "BattleEndFled"         => "Trigger: 'BattleEndFled'\n({2}, {1})",
    "BattleEndCapture"      => "Trigger: 'BattleEndCapture'\n({2}, {1})"
  } 
  
  #-----------------------------------------------------------------------------
  # Demo trainer speech when triggering Mega Evolution.
  #-----------------------------------------------------------------------------
  DEMO_MEGA_EVOLUTION = {
    "BeforeMegaEvolution_foe"           => "C'mon, {1}!\nLet's blow them away with Mega Evolution!",
    "AfterMegaEvolution_GYARADOS_foe"   => "Behold the serpent of the darkest depths!",
    "AfterMegaEvolution_GENGAR_foe"     => "Good luck escaping THIS nightmare!",
    "AfterMegaEvolution_KANGASKHAN_foe" => "Parent and child fight as one!",
    "AfterMegaEvolution_AERODACTYL_foe" => "Prepare yourself for my prehistoric beast!",
    "AfterMegaEvolution_FIRE_foe"       => "Maximum firepower!",
    "AfterMegaEvolution_ELECTRIC_foe"   => "Prepare yourself for a mighty force of nature!",
    "AfterMegaEvolution_BUG_foe"        => "My mighty insect has emerged from its cacoon!"
  }
  
  #-----------------------------------------------------------------------------
  # Demo trainer speech when triggering Primal Reversion.
  #-----------------------------------------------------------------------------
  DEMO_PRIMAL_REVERSION = {
    "BeforePrimalReversion_foe"        => "Prepare yourself for an ancient force beyond imagination!",
    "AfterPrimalReversion_KYOGRE_foe"  => "{1}!\nLet the seas burst forth from your mighty presence!",
    "AfterPrimalReversion_GROUDON_foe" => "{1}!\nLet the ground crack beneath your mighty presence!",
    "AfterPrimalReversion_WATER_foe"   => "Flood the world with your majesty!",
    "AfterPrimalReversion_GROUND_foe"  => "Shatter the world with your majesty!"
  }
  
  
################################################################################
# Example demo of a generic capture tutorial battle.
################################################################################

  #-----------------------------------------------------------------------------
  # Suggested Battle Rules:
  #-----------------------------------------------------------------------------
  #   "autoBattle"
  #   "alwaysCapture"
  #   "tutorialCapture"
  #   "tempPlayer"
  #   "tempParty"
  #   "noExp"
  #-----------------------------------------------------------------------------
  
  DEMO_CAPTURE_TUTORIAL = {
    #---------------------------------------------------------------------------
    # General speech events.
    #---------------------------------------------------------------------------
    "RoundStartCommand_player"  => "Hey! A wild Pokémon!\nPay attention, now. I'll show you how to capture one of your own!",
    "BeforeDamagingMove_player" => ["Weakening a Pokémon through battle makes them much easier to catch!",
                                    "Be careful though - you don't want to knock them out completely!\nYou'll lose your chance if you do!",
                                    "Let's try dealing some damage.\nGet 'em, {1}!"],
    "BattlerStatusChange_foe"   => [:Opposing, "It's always a good idea to inflict status conditions like Sleep or Paralysis!",
                                    "This will really help improve your odds at capturing the Pokémon!"],
    #---------------------------------------------------------------------------
    # Turn 1 - Uses a status move on the opponent, if possible.
    #---------------------------------------------------------------------------
    "TurnStart_player" => {
      "useMove"      => "Status_foe",
      "setBattler"   => :Opposing,
      "battlerHPCap" => -1
    },
    #---------------------------------------------------------------------------
    # Continuous - Checks if the wild Pokemon's HP is low. If so, initiates the
    #              capture sequence.
    #---------------------------------------------------------------------------
    "RoundEnd_player_repeat" => {
      "ignoreUntil" => ["TargetTookDamage_foe", "RoundEnd_player_2"],
      "speech_A"    => "The Pokémon is weak!\nNow's the time to throw a Poké Ball!",
      "useItem"     => :POKEBALL,
      "speech_B"    => "Alright, that's how it's done!"
    }
  }
  
  
################################################################################
# Demo scenario vs. wild Rotom that shifts forms.
################################################################################
  
  DEMO_WILD_ROTOM = {
    #---------------------------------------------------------------------------
    # Turn 1 - Disables Poke Balls from being used.
    #---------------------------------------------------------------------------
    "RoundStartCommand_1_foe" => {
      "text_A"       => "{1} emited a powerful magnetic pulse!",
      "playAnim"     => [:CHARGE, :Self, :Self],
      "playSE"       => "Anim/Paralyze3",
      "text_B"       => "Your Poké Balls short-circuited!\nThey cannot be used this battle!",
      "disableBalls" => true
    },
    #---------------------------------------------------------------------------
    # Continuous - Shifts into random form, heals HP/status, and gains new item/ability.
    #---------------------------------------------------------------------------
    "RoundEnd_foe_repeat" => {
      "ignoreUntil"    => "TargetWeakToMove_foe",
      "playAnim"       => [:NIGHTMARE, :Opposing, :Self],
      "battlerForm"    => [:Random, "{1} possessed a new appliance!"],
      "battlerHP"      => 4,
      "battlerStatus"  => :NONE,
      "battlerAbility" => [:MOTORDRIVE, true],
      "battlerItem"    => [:CELLBATTERY, "{1} equipped a Cell Battery it found in the appliance!"]
    },
    #---------------------------------------------------------------------------
    # When Rotom's HP drops to 50% or lower, applies Charge, Magnet Rise, and Electric Terrain.
    #---------------------------------------------------------------------------
    "TargetHPHalf_foe" => {
	  "playAnim"       => [:CHARGE, :Self, :Self],
      "battlerEffects" => [
        [:Charge,     5, "{1} began charging power!"],
        [:MagnetRise, 5, "{1} levitated with electromagnetism!"],
      ],
      "changeTerrain"  => :Electric
    },
    #---------------------------------------------------------------------------
    # Player's Pokemon becomes paralyzed after dealing supereffective damage. 
    #---------------------------------------------------------------------------
    "UserMoveEffective_player_repeat" => {
      "text"          => [:Opposing, "{1} emited an electrical pulse out of desperation!"],
      "battlerStatus" => [:PARALYSIS, true]
    }
  }

################################################################################
# Demo scenario vs. Rocket Grunt in a collapsing cave.
################################################################################  
  
  #-----------------------------------------------------------------------------
  # Suggested Battle Rules:
  #-----------------------------------------------------------------------------
  #   "noMoney"
  #   "canLose"
  #-----------------------------------------------------------------------------
  
  DEMO_COLLAPSING_CAVE = {
    #---------------------------------------------------------------------------
    # Turn 1 - Battle intro.
    #---------------------------------------------------------------------------
    "RoundStartCommand_1_foe" => {
      "playSE"  => "Mining collapse",
      "text_A"  => "The cave ceiling begins to crumble down all around you!",
      "speech"  => ["I am not letting you escape!", "I don't care if this whole cave collapses down on the both of us...haha!"],
      "text_B"  => "Defeat your opponent before time runs out!"
    },
    #---------------------------------------------------------------------------
    # Continuous - Text event at the end of each turn.
    #---------------------------------------------------------------------------
    "RoundEnd_player_repeat" => {
      "playSE" => "Mining collapse",
      "text"   => "The cave continues to collapse all around you!"
    },
    #---------------------------------------------------------------------------
    # Turn 2 - Player's Pokemon takes damage and becomes confused.
    #---------------------------------------------------------------------------
    "RoundEnd_2_player" => {
      "text"          => "{1} was struck on the head by a falling rock!",
      "playAnim"      => [:ROCKSMASH, :Opposing, :Self],
      "battlerHP"     => -4,
      "battlerStatus" => :CONFUSED
    },
    #---------------------------------------------------------------------------
    # Turn 3 - Text event.
    #---------------------------------------------------------------------------
    "RoundEnd_3_player" => {
      "text" => ["You're running out of time!", "You need to escape immediately!"]
    },
    #---------------------------------------------------------------------------
    # Turn 4 - Battle prematurely ends in a loss.
    #---------------------------------------------------------------------------
    "RoundEnd_4_player" => {
      "text_A"    => "You failed to defeat your opponent in time!",
      "playAnim"  => ["Recall", :Self],
      "text_B"    => "You were forced to flee the battle!",
      "playSE"    => "Battle flee",
      "endBattle" => 3
    },
    #---------------------------------------------------------------------------
    # Opponent's final Pokemon is healed and increases its defenses when HP is low.
    #---------------------------------------------------------------------------
    "LastTargetHPLow_foe" => {
      "speech"       => "My {1} will never give up!",
      "endSpeech"    => true,
      "playAnim"     => [:BULKUP, :Self],
      "playCry"      => :Self,
      "battlerHP"    => [2, "{1} is standing its ground!"],
      "battlerStats" => [:DEFENSE, 2, :SPECIAL_DEFENSE, 2]
    },
    #---------------------------------------------------------------------------
    # Speech event upon losing the battle.
    #---------------------------------------------------------------------------
    "BattleEndForfeit" => "Haha...you'll never make it out alive!"
  }
  
  
################################################################################
# Demo scenario vs. Battle Quizmaster.
################################################################################ 
  
  #-----------------------------------------------------------------------------
  # Suggested Battle Rules:
  #-----------------------------------------------------------------------------
  #   "canLose"
  #   "noExp"
  #   "noMoney"
  #-----------------------------------------------------------------------------
  
  DEMO_BATTLE_QUIZMASTER = {
    #---------------------------------------------------------------------------
    # Intro speech event.
    #---------------------------------------------------------------------------
    "RoundStartCommand_1_foe" => {
      "speech_A" => ["Welcome to another episode of Pokémon Battle Quiz!", 
                     "The show where trainers must battle with both Pokémon and trivia at the same time!",
                     "You gain one point each time you answer a question correctly, and a bonus point if you knock out a Pokémon!",
                     "If you can reach six points within six turns, you win a prize!",
                     "Is our new challenger up to the task? Let's hear some noise for \\PN!"],
      "playSE"   => "Anim/Applause", 
      "speech_B" => "Now, \\PN!\nLet us begin!"
    },
    #---------------------------------------------------------------------------
    # Speech events.
    #---------------------------------------------------------------------------
    "Variable_1" => {
      "playSE" => "Pkmn move learnt", 
      "speech" => "You've earned yourself your first point!\nKeep your eye on the prize!",
    },
    "Variable_2" => {
      "playSE" => "Pkmn move learnt", 
      "speech" => "Two points - hey, not bad!\nCan our new challenger keep it going?",
    },
    "Variable_3" => {
      "playSE" => "Pkmn move learnt", 
      "speech" => "You've claimed your third point!\nYou're on fire! Keep it up, kid!",
    },
    "Variable_4" => {
      "playSE" => "Pkmn move learnt", 
      "speech" => "Four points on the board!\nDo you think you got what it takes to win?",
    },
    "Variable_5" => {
      "playSE" => "Pkmn move learnt", 
      "speech" => "Just one more point to go!\nCan our up-and-coming star clear a perfect game?",
    },
    "BattleEndLoss" => "Nice try, kid. On to the next challenger!",
    #---------------------------------------------------------------------------
    # Automatically ends the battle as a win if enough points have been earned.
    #---------------------------------------------------------------------------
    "VariableOver_5" => {
      "playSE_A"  => "Pkmn move learnt",
      "speech"    => ["Aaaand there we have it, folks! Point number six!",
                      "Do you know what that means? It looks like we've got a winner!",	  
                      "Let's hear it for our brand new Battle Quiz-wiz - \\PN!"],
      "playSE_B"  => "Anim/Applause", 
      "text"      => "You gracefully bow at the audience to a burst of applause!",
      "endBattle" => 1
    },
    #---------------------------------------------------------------------------
    # Continuous - Adds a bonus point whenever the opponent's Pokemon is KO'd.
    #---------------------------------------------------------------------------
    "BattlerFainted_foe_repeat" => {
      "addVariable" => 1
    },
    #---------------------------------------------------------------------------
    # Continuous - Opponent's final Pokemon always Endures damaging moves.
    #---------------------------------------------------------------------------
    "BeforeDamagingMove_player_repeat" => {
      "ignoreUntil"    => "AfterLastSwitchIn_foe",
      "setBattler"     => :Opposing,
      "battlerEffects" => [:Endure, true]
    },
    #---------------------------------------------------------------------------
    # Turn 1 - Multiple choice question (Region).
    #---------------------------------------------------------------------------
    "RoundEnd_1_foe" => {
      "playSE"     => "Voltorb Flip gain coins", 
      "setChoices" => [:region, 3, {
                        "Kalos" => "Ouch, that's a miss, my friend!",
                        "Johto" => "Close! Well, at least geographically speaking...",
                        "Kanto" => "Ah, good ol' Kanto!\nWhat a classic! Correct!",
                        "Galar" => "Unless you're Champion Leon, that's incorrect!\nI'm afraid you're NOT having a champion time!"
                      }],
      "speech"     => ["Time for our first question!",
                       "In which region do new trainers typically have the option to select Charmander as thier first Pokémon?", :Choices]
    },
    "ChoiceRight_region" => {
      "addVariable"  => 1,
      "playSE"       => "Anim/Applause",
      "text"         => "The crowd politely applauded for you!",
      "setBattler"   => :Opposing,
      "battlerStats" => [:ACCURACY, 1]
    },
    "ChoiceWrong_region" => {
      "setBattler"     => :Opposing,
      "battlerStats"   => [:ACCURACY, -2],
      "battlerEffects" => [:NoRetreat, true, "{1} became nervous!\nIt may no longer escape!"]
    },
    #---------------------------------------------------------------------------
    # Turn 2 - Multiple choice question (Poke Ball).
    #---------------------------------------------------------------------------
    "RoundEnd_2_foe" => {
      "playSE"     => "Voltorb Flip gain coins", 
      "setChoices" => [:pokeball, 4, {
                        "Fast Ball"  => "Perhaps you were a little too fast to answer, because I'm afraid that's incorrect!",
                        "Love Ball"  => "I'm sorry to break your heart, but that's incorrect!", 
                        "Quick Ball" => "Ah, you're a quick-witted one...\nBut unfortunately, not quite quick enough! You're incorrect!",
                        "Heavy Ball" => "Not even a Heavy Ball could contain that huge brain of yours! You're correct!"
                      }],
      "speech"     => ["It's time for our second question!",
                       "Which type of Poké Ball would be most effective if thrown on the first turn at a wild Metagross?", :Choices]
    },
    "ChoiceRight_pokeball" => {
      "addVariable" => 1,
      "playSE"      => "Anim/Applause",
      "text"        => "The crowd began to root for you to win!",
      "setBattler"  => :Opposing,
      "teamEffects" => [:LuckyChant, 5, "The Lucky Chant shields {1} from critical hits!"]
    },
    "ChoiceWrong_pokeball" => {
      "setBattler"   => :Opposing,
      "battlerMoves" => [:SPLASH, :METRONOME, nil, nil],
      "text"         => "{1} became embarassed and forgot its moves!"
    },
    #---------------------------------------------------------------------------
    # Turn 3 - Branching path question.
    #---------------------------------------------------------------------------
    "RoundEnd_3_foe" => {
      "setChoices" => [:topic, nil, "Battling", "Evolution", "Breeding"],
      "speech"     => ["Ah, we've made it to our wild card round!",
                       "This turn, you may choose one of three topics related to Pokémon.",
                       "Our Quiz-A-Tron 3000 will then generate a stumper of a question related to your chosen topic.",
                       "This will be a simple yes or no question, but it will be worth two points, so choose wisely!",
                       "So then, which topic will it be?", :Choices, 
                       "Interesting choice!", 
                       "Let's see what our Quiz-A-Tron comes up with!"],
      "endSpeech"  => true,
      "playSE"     => "PC Access", 
      "text"       => "The Quiz-A-Tron 3000 beeps and whirrs as it prints out a question."
    },
    #---------------------------------------------------------------------------
    # Branch 1 - Multiple choice question (Battle).
    #---------------------------------------------------------------------------
    "Choice_topic_1" => {
      "playSE"     => "Voltorb Flip gain coins",
      "setChoices" => [:battling, 2, {
                        "Yes" => "I'm sorry. I guess not everyone can have a Natural Gift for quizzes...",
                        "No"  => "Hey, looks like you've got a Natural Gift for this!"
                      }],
      "speech"     => ["Question time!",
                       "Would the move Nature Power become an Ice-type move if the user is holding a Yache Berry?", :Choices]
    },
    "ChoiceRight_battling" => {
      "addVariable"  => 2,
      "playSE"       => "Anim/Applause",
      "text"         => "The crowd roared with excitement!",
      "setBattler"   => :Opposing,
      "battlerHP"    => [1, "{1} was energized from the crowd's cheering!"],
      "battlerStats" => [:ATTACK, 1, :SPECIAL_ATTACK, 1]
    },
    "ChoiceWrong_battling" => {
      "setBattler"   => :Opposing,
      "text"         => "{1} became discouraged by the silence of the crowd...",
      "battlerStats" => [:ATTACK, -2, :SPECIAL_ATTACK, -2]
    },
    #---------------------------------------------------------------------------
    # Branch 2 - Multiple choice question (Evolution).
    #---------------------------------------------------------------------------
    "Choice_topic_2" => {
      "playSE"     => "Voltorb Flip gain coins",
      "setChoices" => [:evolution, 1, {
                        "Yes" => "It was critical that you got that question right! Good job!",
                        "No"  => "Oh no! You should have thought about that one more critically..."
                      }],
      "speech"     => ["Question time!",
                       "Would holding a Leek item be directly useful in some way with helping a Galarian Farfetch'd evolve?", :Choices]
    },
    "ChoiceRight_evolution" => {
      "addVariable"  => 2,
      "playSE"       => "Anim/Applause",
      "text"         => "The crowd roared with excitement!",
      "setBattler"   => :Opposing,
      "battlerHP"    => [1, "{1} was energized from the crowd's cheering!"],
      "battlerStats" => [:SPEED, 1, :EVASION, 1]
    },
    "ChoiceWrong_evolution" => {
      "setBattler"   => :Opposing,
      "text"         => "{1} became discouraged by the silence of the crowd...",
      "battlerStats" => [:SPEED, -2, :EVASION, -2]
    },
    #---------------------------------------------------------------------------
    # Branch 3 - Multiple choice question (Breeding).
    #---------------------------------------------------------------------------
    "Choice_topic_3" => {
      "playSE"     => "Voltorb Flip gain coins",
      "setChoices" => [:breeding, 1, {
                        "Yes" => "Whoa! You Volbeat that question without breaking a sweat!",
                        "No"  => "Ouch! Looks you got Volbeat by that question..."
	                    }],
      "speech"     => ["Question time!",
                       "Is Illumise able to produce eggs of a different species from itself?", :Choices]
    },
    "ChoiceRight_breeding" => {
      "addVariable"  => 2,
      "playSE"       => "Anim/Applause",
      "text"         => "The crowd roared with excitement!",
      "setBattler"   => :Opposing,
      "battlerHP"    => [1, "{1} was energized from the crowd's cheering!"],
      "battlerStats" => [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
    },
    "ChoiceWrong_breeding" => {
      "setBattler"   => :Opposing,
      "text"         => "{1} became discouraged by the silence of the crowd...",
      "battlerStats" => [:DEFENSE, -2, :SPECIAL_DEFENSE, -2]
    },
    #---------------------------------------------------------------------------
    # Turn 4 - Final question. 
    #---------------------------------------------------------------------------
    "RoundEnd_4_foe" => {
      "speech_A"   => ["I'm afraid we've reached our final round of questions!",
                       "Can our challenger pull out a win here?\nLet's find out!"],
      "playSE"     => "Voltorb Flip gain coins",
      "setChoices" => [:final, 1, {
                        "Hold the Ctrl key"      => "Yes, it's Ctrl! You got it!\nHey, you must be a pro at this!",
                        "Hold the Shift key"     => "Close! Holding Shift will only recompile plugins!\nThe correct key is Ctrl!",
                        "Hold your face and cry" => "Huh? C'mon now, it's not that hard... Just hold the Ctrl key.",
                        "Ask someone else how"   => "Well now you won't have to, because the answer is 'Hold the Ctrl key'."
                      }],
      "speech_B"   => ["Here it is, the final question:",
                       "When loading Pokémon Essentials in Debug mode and the game window is in focus, how do you manually trigger the game to recompile?", :Choices]
    },
    "ChoiceRight_final" => {
      "addVariable" => 1,
      "playSE"      => "Anim/Applause",
      "text"        => "The crowd gave you a standing ovation!"
    },
    "ChoiceWrong_final" => {
      "text"       => "You can hear disappointed murmurings from the crowd...",
      "setBattler" => :Opposing,
      "battlerHP"  => [-100, "{1} fainted from embarassment..."]
    },
    #---------------------------------------------------------------------------
    # Turn 6 - Ends the battle as a loss if not enough points have been earned.
    #---------------------------------------------------------------------------
    "RoundEnd_6_foe" => {
      "playSE_A"   => "Slots stop",
      "speech_A"   => ["Oh no! That sound means we've reached the end of our game...",
                       "Our challenger \\PN showed much promise, but came up a tad short in the end.",
                       "But we still had fun, didn't we, folks?"], 
      "playSE_B"   => "Anim/Applause",
      "speech_B"   => "That's right! Well, that's all for today!\nTake a bow, \\PN! You and your Pokémon fought hard!",
      "text"       => "You awkwardly bow at the audience as staff begin to direct you off stage...",
      "endBattle"  => 2
    }
  }

#===============================================
#
# IDITE MOD MIDBATTLE SCRIPTS!
#
#===============================================

# Gengar Boss Fight
GENGAR_MIDBATTLE   = {
  "TargetTookDamage_foe_repeat" => {
    "ignoreAfter" => "BattlerHPCritical_foe",
    "text" => "{1} started to regenerate!",
    "battlerHP" => [20, "{1} regenerated some HP!"],
    "battlerHPCap" => 0
  },
  "RoundEnd_player_repeat" => {
    "ignoreAfter" => "BattlerHPCritical_foe",
    "text_A" => "You hear faint whispers...",
    "playSE" => "Repel"
  },
  "RoundEnd_foe_repeat" => {
    "ignoreUntil" => "BattlerHPCritical_foe",
    "text_A" => "The whispers erupt into a mocking cacophony!",
    "battlerStats" => [:Random, 2, :Random, -1]
  },
  "BattlerHPCritical_foe" => {
    "text_A" => "The whispers erupt into a roar! What is happening?!",
    "megaEvolve" => "The shadows flow into Gengar and she changes form!",
    "playSE" => "Mining collapse",
    "text" => "Mega Gengar sucks the light out of the room!",
    "changeBackdrop" => "cave3",
    "wait" => 0.5,
    "playAnim" => :BULKUP,
    "wait" => 0.3,
    "playCry" => :Self,
    "battlerHP" => [100, "{1} regenerated a lot of HP!"],
    "battlerStats" => [:SPECIAL_ATTACK, 2],
    "battlerMoves" => [:STOREDPOWER, :SHADOWBALL, :SLUDGEWAVE, :DARKPULSE]
  }
}

# Rookidee Boss Fight
ROOKIDEE_MIDBATTLE   = {
   "RoundStartCommand_1_foe" => {
     "playSE"  => "Mining collapse",
     "text_A"  => "The den ceiling begins to crumble down all around you!",
     "text_B"  => "You're on the clock... Finish this fast!",
     "battlerHPCap" => 50
  },
   "BattlerReachedHPCap_foe" => {
     "battlerAbility" => :HUGEPOWER,
     "text" => "Rookidee found her hidden power... Her HUGE Power!"
  },
   "RoundEnd_player_repeat" => {
     "playSE" => "Mining collapse",
     "speech"   => "Rookidee sends a defiant glare at you! She's not going anywhere!"
  },
   "RoundEnd_2_player" => {
     "text"          => "{1} was struck on the head by a falling rock!",
     "playAnim"      => [:ROCKSMASH, :Opposing, :Self],
     "battlerHP"     => -25,
     "battlerStatus" => :CONFUSED
  },
   "RoundEnd_4_player" => {
     "text" => ["You're running out of time!", "You need to escape immediately!"]
  },
   "RoundEnd_5_player" => {
     "text_A"    => "You failed to defeat your opponent in time!",
     "playAnim"  => ["Recall", :Self],
     "text_B"    => "You were forced to flee the battle!",
     "playSE"    => "Battle flee",
     "endBattle" => 3
  },
   "BattlerHPCritical_foe" => {
     "speech"       => "{1} will never give up!",
     "endSpeech"    => true,
     "playAnim"     => [:BULKUP, :Self],
     "playCry"      => :Self,
     "battlerHP"    => [50, "{1} is standing its ground!"],
     "battlerStats" => [:DEFENSE, 2, :SPECIAL_DEFENSE, 2]
  }
}

#Froslass Boss Fight
FROSLASS_MIDBATTLE   = {
  # Be smart about those fire types! 
  "AfterSendOut_FIRE_player" => {
    "text" => "{1}'s heat melts the ice! {1} starts to sink into the slush!",
    "setBattler_A" => 0,
    "battlerStats_A" => [:SPEED, -1],
    "changeWeather" => :Rain,
    "setBattler_B" => 1, 
    "dynamax" => "Froslass absorbs the excess ice into herself... She's Dynamaxing!",
    "battlerStats_B" => [:DEFENSE, 2, :SPECIAL_DEFENSE, 2],
    "playCry" => :Self
  },
  # What could she be doing?
  "TurnStart_1_foe_repeat_every_3" => {
    "ignoreAfter" => "AfterSendOut_FIRE_player",
    "speech" => "{1} gathers energy. You can feel the temperature plummet.",
    "changeWeather" => :Snow,
    "endSpeech" => true,
    "battlerHPCap" => 0
  },
  # Oh, that's what she was doing.
   "TurnStart_2_foe_repeat_every_3" => {
    "ignoreAfter" => "AfterSendOut_FIRE_player",
      "speech" => "{1} continues to gather energy... Something is about to happen!",
      "endSpeech" => true,
      "playCry" => :Self
  },
  # Boom, you're frozen. Get fucked, nerd.
  "TurnStart_3_foe_repeat_every_3" => {
    "ignoreAfter" => "AfterSendOut_FIRE_player",
    "speech" => "{1} gathers energy. You can feel the temperature plummet.",
    "setBattler" => :Opposing,
    "battlerStatus" => :NONE,
    "battlerStatus" => :FREEZE,
    "endSpeech" => true,
    "battlerHPCap" => 0
  },
  # Final Stand, featuring the Rainbow field effect! I'm sure everybody knows exactly what that one does and nobody will be confused.
  "BattlerReachedHPCap_foe" => {
    "speech" => "{1} endured the hit! She's not going down quite yet!!",
    "playCry" => :Self,
    "endspeech" => true,
    "teamEffects" => [:Rainbow, 5, "A break in the clouds reveals a shimmering Rainbow!"],
    "battlerHP" => [25, "{1} absorbed water into herself."],
    "battlerStats" => [:SPECIAL_ATTACK, 1, :SPECIAL_DEFENSE, 2, :SPEED, 3]
 }
}

MIST_GRENINJA1 = {
  "RoundStartCommand_1_foe" => {
    "speech" => ["The Greninja emerges from the shadows, ready to strike like a true shinobi!"],
    "setVariable" => 0,
    "changeTerrain" => :Misty,
    "battlerStats" => [:EVASION, 6, :SPEED, 6, :SPECIAL_ATTACK, 6]
  },
  "TargetTookDamage_foe_repeat" => {
    "addVariable" => 1,
    "text" => ["Greninja vanishes into shadows, creating illusions!"],
  },
  "TargetHPHalf_foe" => {
    "speech" => ["Greninja performs the forbidden jutsu—shadow clones multiply!"],
    "addWild" => [:GRENINJA, 50],
    "battlerStats" => [:ATTACK, 2, :SPECIAL_ATTACK, 2]
  },
  "VariableUp_repeat_every_3" => {
    "text" => ["The shadow clones overwhelm the battlefield!"],
    "battlerStats" => [:EVASION, 1, :SPEED, 1],
	"setBattler" => :Opposing,
    "battlerEffects_foe" => [:Confusion, 2, "The shadows confuse your Pokémon!"]
},
  "BattlerFainted_foe" => {
    "text" => ["The shinobi Greninja fades into the shadows, defeated..."],
    "changeTerrain" => :None,
    "changeWeather" => :None
  }
}

MIST_GRENINJA2 = {
  "RoundStartCommand_1_foe" => {
    "speech" => ["The Greninja emerges from the shadows, ready to strike like a true shinobi!"],
    "setVariable" => 0,
    "changeTerrain" => :Misty,
    "battlerStats" => [:EVASION, 4, :SPEED, 4, :SPECIAL_ATTACK, 4]
  },
  "TargetTookDamage_foe_repeat" => {
    "addVariable" => 1,
    "text" => ["Greninja vanishes into shadows, creating illusions!"],
  },
  "TargetHPHalf_foe" => {
    "speech" => ["Greninja performs the forbidden jutsu—shadow clones multiply!"],
    "addWild" => [:GRENINJA, 45],
    "battlerStats" => [:ATTACK, 2, :SPECIAL_ATTACK, 2]
  },
  "VariableUp_repeat_every_3" => {
    "text" => ["The shadow clones overwhelm the battlefield!"],
    "battlerStats" => [:EVASION, 1, :SPEED, 1],
	"setBattler" => :Opposing,
    "battlerEffects_foe" => [:Confusion, 2, "The shadows confuse your Pokémon!"]
},
  "BattlerFainted_foe" => {
    "text" => ["The shinobi Greninja fades into the shadows, defeated..."],
    "changeTerrain" => :None,
    "changeWeather" => :None
  }
}

MIST_GRENINJA3 = {
  "RoundStartCommand_1_foe" => {
    "speech" => ["The Greninja emerges from the shadows, ready to strike like a true shinobi!"],
    "setVariable" => 0,
    "changeTerrain" => :Misty,
    "battlerStats" => [:EVASION, 3, :SPEED, 3, :SPECIAL_ATTACK, 3]
  },
  "TargetTookDamage_foe_repeat" => {
    "addVariable" => 1,
    "text" => ["Greninja vanishes into shadows, creating illusions!"],
  },
  "TargetHPHalf_foe" => {
    "speech" => ["Greninja performs the forbidden jutsu—shadow clones multiply!"],
    "addWild" => [:GRENINJA, 40],
    "battlerStats" => [:ATTACK, 2, :SPECIAL_ATTACK, 2]
  },
  "VariableUp_repeat_every_3" => {
    "text" => ["The shadow clones overwhelm the battlefield!"],
    "battlerStats" => [:EVASION, 1, :SPEED, 1],
	"setBattler" => :Opposing,
    "battlerEffects_foe" => [:Confusion, 2, "The shadows confuse your Pokémon!"]
},
  "BattlerFainted_foe" => {
    "text" => ["The shinobi Greninja fades into the shadows, defeated..."],
    "changeTerrain" => :None,
    "changeWeather" => :None
  }
}

MIST_GRENINJA4 = {
  "RoundStartCommand_1_foe" => {
    "speech" => ["The Greninja emerges from the shadows, ready to strike like a true shinobi!"],
    "setVariable" => 0,
    "changeTerrain" => :Misty,
    "battlerStats" => [:EVASION, 2, :SPEED, 2, :SPECIAL_ATTACK, 2]
  },
  "TargetTookDamage_foe_repeat" => {
    "addVariable" => 1,
    "text" => ["Greninja vanishes into shadows, creating illusions!"],
  },
  "TargetHPHalf_foe" => {
    "speech" => ["Greninja performs the forbidden jutsu—shadow clones multiply!"],
    "addWild" => [:GRENINJA, 40],
    "battlerStats" => [:ATTACK, 2, :SPECIAL_ATTACK, 2]
  },
  "VariableUp_repeat_every_3" => {
    "text" => ["The shadow clones overwhelm the battlefield!"],
    "battlerStats" => [:EVASION, 1, :SPEED, 1],
	"setBattler" => :Opposing,
    "battlerEffects_foe" => [:Confusion, 2, "The shadows confuse your Pokémon!"]
},
  "BattlerFainted_foe" => {
    "text" => ["The shinobi Greninja fades into the shadows, defeated..."],
    "changeTerrain" => :None,
    "changeWeather" => :None
  }
}

MIST_GRENINJA = {
  "RoundStartCommand_1_foe" => {
    "speech" => ["The Greninja emerges from the shadows, ready to strike like a true shinobi!"],
    "setVariable" => 0,
    "changeTerrain" => :Misty,
    "battlerStats" => [:EVASION, 1, :SPEED, 1]
  },
  "TargetTookDamage_foe_repeat" => {
    "addVariable" => 1,
    "text" => ["Greninja vanishes into shadows, creating illusions!"],
  },
  "TargetHPHalf_foe" => {
    "speech" => ["Greninja performs the forbidden jutsu—shadow clones multiply!"],
    "addWild" => [:GRENINJA, 30],
    "battlerStats" => [:ATTACK, 2, :SPECIAL_ATTACK, 2]
  },
  "VariableUp_repeat_every_3" => {
    "text" => ["The shadow clones overwhelm the battlefield!"],
    "battlerStats" => [:EVASION, 1, :SPEED, 1],
	"setBattler" => :Opposing,
    "battlerEffects_foe" => [:Confusion, 2, "The shadows confuse your Pokémon!"]
},
  "BattlerFainted_foe" => {
    "text" => ["The shinobi Greninja fades into the shadows, defeated..."],
    "changeTerrain" => :None,
    "changeWeather" => :None
  }
}

#=======================================================
# Changed Vanilla Boss Battles
#=======================================================

ANGRY_RALTS_RAMPAGE = {
  "RoundStartCommand_1_foe" => {
    "text" => ["The Ralts stares at you with furious eyes, its rage palpable!"],
    "setVariable" => 0, # Start hit/rage counter at 0
    "changeTerrain" => :Psychic
  },
  "TargetTookDamage_foe_repeat" => {
    "addVariable" => 1, # Increment the hit counter
    "text" => ["Ralts's rage intensifies from the pain!"]
  },
  "VariableUp_repeat_every_3" => {
    "text" => ["Ralts is in a full rampage! Its movements are unpredictable!"],
    "battlerStats" => [:EVASION, 1, :DEFENSE, 1]
  },
  "TargetHPHalf_foe" => {
    "speech" => ["Ralts lets out a piercing scream, its power surging uncontrollably!"],
    "battlerHP" => [20, "{1} channels its anger to recover some energy!"],
    "battlerStats" => [:SPECIAL_ATTACK, 1, :SPECIAL_DEFENSE, 1],
    "changeWeather" => :Hail
  },
  "BattlerFainted_foe" => {
    "text" => ["The Ralts collapses, its rampage finally ended..."],
    "changeTerrain" => :None,
    "changeWeather" => :None
  }
}

# Vaporeon Boss Fight
VAPOREON_MIDBATTLE   = {
  # Lol. Lmao, even. 
  "RoundEnd_foe_repeat" => {
    "ignoreAfter" => "BattlerReachedHPCap_foe",
    "changeTerrain" => :Electric,
    "changeWeather" => :Rain,
    "setBattler" => :Opposing,
    "text" => "Vaporeon manipulates the water beneath {1}!",
    "playCry" => :Self,
    "battlerStats" => [:SPEED, -1],
  },
  # You've been... THUNDERSTRUCK!
  "TurnStart_1_foe" => {
    "speech" => "Vaporeon calls forth a storm front!",
    "changeBackdrop" => "water_night",
    "changeTerrain" => :Electric,
    "changeWeather" => :Rain,
    "endSpeech" => true,
    "battlerHPCap" => -1
  },
  # Final Stand, featuring the Rainbow field effect! I'm sure everybody knows exactly what that one does and nobody will be confused.
  "BattlerReachedHPCap_foe" => {
    "speech" => "{1} endured the hit! She's not going down quite yet!!",
    "playCry" => :Self,
    "endspeech" => true,
    "teamEffects" => [:Rainbow, 5, "A break in the clouds reveals a shimmering Rainbow!"],
    "battlerHP" => [25, "{1} absorbed water into herself."],
    "battlerStats" => [:SPECIAL_ATTACK, 1, :SPECIAL_DEFENSE, 2, :SPEED, 3]
 }
}

DRAGONAIR_MIDBATTLE = {
  "RoundStartCommand_1_foe" => {
    "text" => ["The Dragonair coils defensively, claiming this ocean route as its territory!"],
    "setVariable" => 0,
    "changeWeather" => :Rain,
    "changeTerrain" => :Misty
  },
  "TargetTookDamage_foe_repeat" => {
    "addVariable" => 1,
    "text" => ["Dragonair roars, defending its turf with greater fury!"]
},
  "VariableUp_repeat_every_3" => {
    "battlerStats" => [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
    "battlerEffects" => [:AquaRing, true, "Waves trap your Pokémon in a whirlpool!"]
},
  "TargetHPHalf_foe" => {
    "speech" => ["Dragonair summons the ocean's wrath in desperation!"],
    "battlerStats" => [:ATTACK, 2, :SPECIAL_ATTACK, 2],
    "changeWeather" => :HeavyRain
 }
}

GOODRA_MIDBATTLE = {
  "RoundStartCommand_1_foe" => {
    "text" => ["The Goodra is blocking your path!"],
    "setVariable" => 0,
    "changeWeather" => :Rain,
  },
  "TargetTookDamage_foe_repeat" => {
    "addVariable" => 1,
    "text" => ["Goodra roars with greater fury!"]
  },
  "VariableUp_repeat_every_3" => {
    "battlerStats" => [:DEFENSE, 2, :SPECIAL_DEFENSE, 2],
    "battlerEffects" => [:Mist, true, "Goodra's goo forms a protective mist!"]
  },
  "TargetHPHalf_foe" => {
    "speech" => ["Goodra Secrete oil to increase it's defense!"],
    "battlerStats" => [:SPECIAL_DEFENSE, 3, :SPECIAL_ATTACK, 3],
    "changeWeather" => :HeavyRain
  }
}

SMEARGLE_MIDBATTLE = {
  "RoundStartCommand_1_foe" => {
    "setSpeaker" => :PAINTER,
    "speech" => ["Behold! She'll paint a battlefield masterpiece with your defeat!"],
    "playSE" => "Anim/Sketch",
	"battlerHPCap" => 24,
    "battlerStats" => [:EVASION, 1],
    "changeTerrain" => :Grassy,
    "text" => ["{1} dips its tail in vibrant paint and slashes the air!"]
  },
  "RoundStartCommand_foe_repeat_every_3" => {
    "text" => ["{1} adds a wild stroke of color to the canvas!"],
    "playSE" => "Anim/Splash",
    "changeTerrain" => :Random,
    "ignoreAfter" => "TerrainEnded"
  },
  "TargetTookDamage_foe" => {
    "addVariable" => 1,
    "text" => ["{1} swiftly sketches your attack with its tail!"],
    "playSE" => "Anim/Sketch",
    "ignoreAfter" => "Variable_repeat_every_3"
  },
  "Variable_repeat_every_3" => {
    "setBattler" => :Opposing,
    "battlerStats" => [:ATTACK, 1, :DEFENSE, 1, :SPEED, 1],
    "text" => ["The sketch animates! {1} grows fiercer and more agile!"],
    "playSE" => "Anim/DragonDance"
  },
  "UserMoveDodged_foe" => {
    "battlerStats" => [:EVASION, 1],
    "text" => ["{1} dodges with an elegant brush stroke!"],
    "playSE" => "Anim/DoubleTeam"
  },
  "TargetHPHalf_foe" => {
    "ignoreAfter" => "TargetHPHalf_foe",
    "setChoices" => [:paintColor, nil, {
      "Red"   => "Red paint ignites passion! Power surges through {1}!",
      "Blue"  => "Blue paint forms an impervious shield around {1}!",
      "Green" => "Green paint draws life from the earth! {1} revitalizes!"
    }],
	"setSpeaker" => :PAINTER,
    "speech" => ["Ah, The final colors for her masterpiece! Choose the hue!" , :Choices],
    "battlerHP" => [33, "{1} licks revitalizing paint from its tail!"],
    "playSE" => "Anim/Recover"
  },
  "Choice_paintColor_1" => {
    "battlerStats" => [:SPECIAL_ATTACK, 1, :ACCURACY, 1, :ATTACK, 1],
    "changeWeather" => :Sun,
	"battlerMoves" => [:STOREDPOWER, :WILLOWISP, :MEGAKICK, :FIREBLAST],
	"battlerForm" => 2,
    "text" => ["Crimson flames erupt from the red paint!"],
    "playSE" => "Anim/SunnyDay"
  },
  "Choice_paintColor_2" => {
    "battlerStats" => [:DEFENSE, 2, :SPECIAL_DEFENSE, 2],
    "changeWeather" => :Rain,
	"battlerMoves" => [:STOREDPOWER, :TOXIC, :SCALD, :THUNDER],
	"battlerForm" => 3,
    "text" => ["Sapphire waves crash, fortifying {1}!"],
    "playSE" => "Anim/RainDance"
  },
  "Choice_paintColor_3" => {
    "battlerStats" => [:SPEED, 2, :SPECIAL_ATTACK, 1],
	"battlerMoves" => [:STOREDPOWER, :THUNDERWAVE, :HYPERVOICE, :ELECTROBALL],
    "changeTerrain" => :Electric,
	"battlerForm" => 4,
    "playSE" => "Anim/GrassyTerrain"
  },
  "BattlerHPLow_foe" => {
    "ignoreAfter" => "BattlerHPLow_foe",
    "speech" => ["Sme...argle! (defiant)"],
    "text" => ["{1} shakes off ailments with artistic resolve!"],
    "playSE" => "Anim/Splash"
  },
  "BattlerReachedHPCap_foe" => {
	"addWild" => [:SMEARGLEsg_1, 50],
	"setSpeaker" => :PAINTER,
    "speech" => ["Behold! Life imitating art!"],
    "playSE" => "Anim/Sketch"
  }
}

WHIMSCOTT_MIDBATTLE = {
  "RoundStartCommand_1_foe" => {
    "changeTerrain" => :Misty,
    "battlerHPCap" => 49,
    "playSE" => "Anim/Fairy",
    "text" => ["{1} flutters about playfully!"]
  },
  "UserMoveDodged_repeat" => {
    "setBattler" => :Self,
    "battlerStats" => [:EVASION, 1, :SPEED, 1],
    "text" => ["{1} dances away nimbly!"],
    "playSE" => "Anim/CottonSpore"
  },
  "TargetResistedMove_repeat_random_50" => {
    "battlerHP" => [15, "{1} absorbs the blow with its fluffy body!"],
    "text" => ["{1} giggles mockingly!"]
  },
  "TargetWeakToMove" => {
    "ignoreAfter" => "TargetWeakToMove",
    "battlerHP" => [30, "{1} shakes it off with a prank!"],
    "battlerStats" => [:SPECIAL_ATTACK, 2],
    "text" => ["{1} turns the tables with fairy mischief!"],
    "playSE" => "Anim/PlayRough"
  },
  "BattlerReachedHPCap_foe" => {
    "dynamax" => true,
    "text" => ["{1} grows massive, swirling with chaotic winds!"]
  }
}
#-------------------------------------
# Idite Mod Trainer Battle Scripts
#-------------------------------------

# BunnE
BUNNE_MIDBATTLE   = {
  "TurnStart_foe_1" => {
    "speech" => "The battle for the... uh... STEEL BADGE! starts now!",
    "changeTerrain" => :Electric,
    "endspeech" => true,
  },
  "AfterLastSwitchIn_foe" => {
    "speech" => "Very good! But have you considered that I'm straight-up CHEATING?!",
    "addTrainer" => ["EASTEREGG", "BunnE", 1],
    "endspeech" => true,
  },
  "AfterSwitchIn_STEELIX_foe" => {
    "disableMegas" => false,
    "megaEvolve" => "Steelix gathers energy and Mega Evolves!",
    "changeWeather" => :Sandstorm
  },
  "AfterSwitchIn_MAWILE_foe" => {
    "disableMegas" => false,
    "megaEvolve" => "Mawile gathers energy and Mega Evolves!",
    "changeTerrain" => :Misty
  },
  "AfterSwitchIn_LUCARIO_foe" => {
    "disableMegas" => false,
    "megaEvolve" => "Lucario gathers energy and Mega Evolves!",
    "battlerStats" => [:ATTACK, 3]
  } 
}

# Graveler Repeatable (Machoke Sidequest)
GRAVELLER_SIDEQUEST = {
"TurnStart_1_player" => {
     "playSE"  => "Mining collapse",
     "battlerHP" => -13,
     "text" => "The POKéMON landed on your {1}!"
  }
}

MACHOKE_MIDBATTLE   = {
  # Oh, you're gonna use multiple Pokemon? Cute.
  "AfterSwitchIn_player_repeat" => { # The "repeat" is important.
    "setVariable" => 0, # Resets the variable to 0
    "addVariable" => [1,2,3,4] # Acts as RNG
  },
  "Variable_1_repeat" => { # If you do not have "repeat", this can only trigger once per battle.
    "setBattler_A" => :Self,
    "text_A" => [:Opposing, "My God! Here comes {1} with a steel chair!"],
    "playAnim_A" => [:IRONTAIL, :Opposing, :Self],
    "battlerHP_A" => -33,
    "setBattler_B" => :Opposing,
    "text_B" => "{1} strikes a pose before readying herself for battle!",
    "playCry_B" => :Self,
    "playAnim_B" => [:BULKUP, :Self],
    "battlerHP_B" => 33,
    "battlerStats" => [:SPEED, 1, :DEFENSE, 1, :SPECIAL_DEFENSE, 1]
  },
  "Variable_2_repeat" => {
    "setBattler_A" => :Self,
    "text_A" => [:Opposing, "Oh! It's {1} from the top rope!"],
    "playAnim_A" => [:SKYUPPERCUT, :Opposing, :Self],
    "battlerHP_A" => -13,
    "battlerStatus_A" => :CONFUSED,
    "setBattler_B" => :Opposing,
    "text_B" => "{1} strikes a pose before readying herself for battle!",
    "playCry_B" => :Self,
    "playAnim_B" => [:BULKUP, :Self],
    "battlerHP_B" => 33,
    "battlerStats" => [:SPEED, 1, :ATTACK, 1]
  },
  "Variable_3_repeat" => {
    "setBattler_A" => :Self,
    "text_A" => [:Opposing, "{1} jumps up and lands the People's Elbow!"],
    "playAnim_A" => [:SEISMICTOSS, :Opposing, :Self],
    "battlerHP_A" => -50,
    "setBattler_B" => :Opposing,
    "text_B" => "{1} strikes a pose before readying herself for battle!",
    "playCry_B" => :Self,
    "playAnim_B" => [:BULKUP, :Self],
    "battlerHP_B" => 33,
    "battlerStats" => [:DEFENSE, 1, :ATTACK, 1]
  },
  "Variable_4_repeat" => {
    "setBattler_A" => :Self,
    "text_A" => [:Opposing, "{1} strikes a pose. Somewhere in the distance, you hear it:"],
    "setSpeaker_D" => :CRASHERWAKE,
    "speech_D" => "OOOOOOH YEAH, BROTHER! CRAASSSSSSSHER WAAAAAAAAKE!!",
    "playAnim_A" => [:SEISMICTOSS, :Opposing, :Self],
    "battlerHP_A" => -50,
    "setBattler_B" => :Opposing,
    "text_B" => "{1} crosses her arms!",
    "playCry_B" => :Self,
    "playAnim_B" => [:BULKUP, :Self],
    "battlerHP_B" => 33,
    "battlerStats" => [:ATTACK, 2]
  }
}

MARACTUS_MIDBATTLE = {
  "RoundStartCommand_1_foe" => {
    "addWild" => [:MARACTUSx_1, 45],
    "playSE" => "Anim/HyperVoice",
    "changeWeather" => :Sandstorm,
    "changeTerrain" => :Grassy,
    "battlerStats" => [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
    "text" => ["{1} shakes its maraca buds, filling the air with rhythmic beats!"],
    "addVariable" => 1
  },
  "Variable_1" => {
    "addWild" => [:MARACTUSx_1, 45]
  },
  "TargetTookDamage_foe" => {
    "addVariable" => 1,
    "text" => ["{1} shakes harder, building the rhythm!"],
    "playSE" => "Anim/BulletSeed",
    "ignoreUntil" => ["Variable_4", "Variable_8"]
  },
  "Variable_4" => {
    "battlerStats" => [:SPEED, 1, :ATTACK, 1],
    "text" => ["The beat quickens! {1} dances with vigor!"],
    "playSE" => "Anim/DragonDance"
  },
  "Variable_8" => {
    "battlerHP" => [30, "{1} draws energy from the rhythm!"],
    "battlerStats" => [:SPEED, 2, :ATTACK, 2],
    "text" => ["Crescendo! {1}'s song grows powerful!"],
    "playSE" => "Anim/GrassWhistle"
  },
  "UserMoveDodged_foe" => {
    "battlerStats" => [:EVASION, 1],
    "text" => ["{1} sways to the rhythm, dodging gracefully!"],
    "playSE" => "Anim/DoubleTeam"
  },
  "TargetHPHalf_foe" => {
    "ignoreAfter" => "TargetHPHalf_foe",
    "speech" => ["Marac~tuuus! (melodic)", "The rhythm intensifies!"],
    "battlerStats" => [:SPEED, 1, :ATTACK, 1, :DEFENSE, 1],
    "changeWeather" => :Sun,
    "text" => ["{1} enters a frenzied dance, boosting its power!"],
    "playSE" => "Anim/SwordsDance"
  },
  "BattlerHPLow_foe" => {
    "ignoreAfter" => "BattlerHPLow_foe",
    "battlerStatus" => [:None, "{1} shakes off the funk!"],
    "battlerHP" => [25, "{1} heals with a healing melody!"],
    "playSE" => "Anim/HealBell",
    "text" => ["The music purges weakness!"]
   }
 }
 
# Vulpix
VULPIX_MIDBATTLE   = {
  "AfterSendOut_WATER_player" => {
    "setBattler" => :Opposing,
    "battlerForm" => 1,
    "text" => "Oh? The wild Vulpix adapted to your swap!",
    "playCry" => :Self,
    "battlerAbility" => :SNOWWARNING,
    "battlerMoves" => [:FREEZEDRY, :AURORAVEIL, :BLIZZARD, :DAZZLINGGLEAM],
    "battlerHP" => 6
  },
  "AfterSendOut_GROUND_player" => {
    "setBattler" => :Opposing,
    "battlerForm" => 1,
    "text" => "Oh? The wild Vulpix adapted to your swap!",
    "playCry" => :Self,
    "battlerAbility" => :SNOWWARNING,
    "battlerMoves" => [:FREEZEDRY, :AURORAVEIL, :BLIZZARD, :DAZZLINGGLEAM],
    "battlerHP" => 17
  },
  "AfterSendOut_FLYING_player" => {
    "setBattler" => :Opposing,
    "battlerForm" => 1,
    "text" => "Oh? The wild Vulpix adapted to your swap!",
    "playCry" => :Self,
    "battlerAbility" => :SNOWWARNING,
    "battlerMoves" => [:FREEZEDRY, :AURORAVEIL, :BLIZZARD, :DAZZLINGGLEAM],
    "battlerHP" => 17
  },
  # Regular Vulpix. Ignores Grass because both are good against it.
  "AfterSendOut_BUG_player" => {
    "setBattler" => :Opposing,
    "battlerForm" => 0,
    "text" => "Oh? The wild Vulpix adapted to your swap!",
    "playCry" => :Self,
    "battlerAbility" => :DROUGHT,
    "battlerMoves" => [:FLAMETHROWER, :INCINERATE, :DARKPULSE, :HYPNOSIS],
    "battlerHP" => 17
  },
  "AfterSendOut_ICE_player" => {
    "setBattler" => :Opposing,
    "battlerForm" => 0,
    "text" => "Oh? The wild Vulpix adapted to your swap!",
    "playCry" => :Self,
    "battlerAbility" => :DROUGHT,
    "battlerMoves" => [:FLAMETHROWER, :INCINERATE, :SHOCKWAVE, :HYPNOSIS],
    "battlerHP" => 17
  },
  "AfterSendOut_STEEL_player" => {
    "setBattler" => :Opposing,
    "battlerForm" => 0,
    "text" => "Oh? The wild Vulpix adapted to your swap!",
    "playCry" => :Self,
    "battlerAbility" => :DROUGHT,
    "battlerMoves" => [:FLAMETHROWER, :INCINERATE, :DARKPULSE, :HYPNOSIS],
    "battlerHP" => 17
  }
}

GYM3_MIDBATTLE   = {
  "AfterSwitchIn_player_repeat_odd" => { 
    "ignoreAfter" => "AfterSendOut_BELLIBOLT_foe",
    "setVariable" => 0, 
    "addVariable" => [1,2,3,4,5,6]
  },
  "RoundEnd_player_repeat_odd" => { 
    "ignoreAfter" => "AfterSendOut_BELLIBOLT_foe",
    "setVariable" => 0, 
    "addVariable" => [1,2,3,4,5,6]
  },
  # Battler Indexes: 0 player left, 1 player middle, 2 player right, 3 foe left, 4 foe middle, 5 foe right. 
  "Variable_1_repeat" => { 
    "setSpeaker" => :LEADER_Iono,
    "speech_A" => "Ohmygosh! Thank you, viewer, for sending some Bad Vibez to the Challenger! They're like, totally not cool.",
    "setBattler_A" => 0, # Left Player Battler
    "battlerStatus_A" => :PARALYSIS,
    "setBattler_B" => 2, # Right Player Battler
    "battlerStatus_B" => :PARALYSIS
  },
  "Variable_2_repeat" => {
    "setBattler_A" => 3,
    "setSpeaker" => :LEADER_Elesa,
    "speech" => "Mmm, a Hot Drop? Viewer, you're too kind to us... Thank you, baby!",
    "battlerHP_A" => 20,
    "setBattler_B" => 5,
    "battlerHP_B" => 20
  },
  "Variable_3_repeat" => {
    "setBattler_A" => :Opposing,
    "setSpeaker" => :LEADER_Iono,
    "speech" => "Nyohoho!! Viewer, thank you for the rain!",
    "setSpeaker_C" => :LEADER_Elesa,
    "speech_C" => "Ohhhhh. I'll grab my umbrella...",
    "changeWeather" => :Rain
  },
  "Variable_4_repeat" => {
    "setBattler_A" => :Opposing,
    "setSpeaker" => :LEADER_Elesa,
    "speech" => "Electric Terrain? My my, viewer, how naughty!",
    "setSpeaker_B" => :LEADER_Iono,
    "speech_B" => "Wow! This'll be a huge hit!",
    "changeTerrain" => :Electric
  },
  "Variable_5_repeat" => {
    "setSpeaker" => :LEADER_Iono,
    "speech" => "A donation for us! X-items? Wow, chat! I love you guys!",
    "setBattler_A" => 3,
    "battlerStats_A" => [:ATTACK, 1, :SPECIAL_ATTACK, 1],
    "setBattler_B" => :Ally,
    "battlerStats_B" => [:ATTACK, 1, :SPECIAL_ATTACK, 1]
  },
  "Variable_6_repeat" => {
    "setBattler_A" => 0,
    "setSpeaker" => :LEADER_Elesa,
    "speech" => "A donation for... the Challenger?!",
    "setSpeaker_B" => :LEADER_Iono,
    "speech_B" => "UGH. Chat, quit being goblins!",
    "battlerStats_A" => [:ATTACK, 1, :SPECIAL_ATTACK, 1],
    "setBattler_B" => :Ally,
    "battlerStats_B" => [:ATTACK, 1, :SPECIAL_ATTACK, 1]
  },
  "AfterLastSendOut_foe" => {
    "dynamax" => "Elesa: Mmm... Time to go bigger! Size matters, you know.",
    "teamEffects" => [:IonDeluge, 5, "The battlefield is amped! Normal-Type moves will change Type!"],
    "setBattler_A" => 3,
    "battlerHP_A" => 50,
    "setBattler_B" => :Ally,
    "battlerHP_B" => 50
  },
  "AfterSendOut_foe_GHOST" => {
    "terastallize" => "Iono: Nyohoho! Time to - bzzt - shock 'em!"
  },
  "BattlerFainted_player_repeat" => {
    "speech" => [:Opposing, "Alllll righty! Time for a Hype Beast!!",
                 :OpposingAlly, "Ooh, yes. Thank you for the donation, baby!"],
    "setBattler_A" => :Opposing,
    "battlerStats_A" => [:ATTACK, 1, :SPECIAL_ATTACK, 1],
    "setBattler_B" => :OpposingAlly,
    "battlerStats_B" => [:ATTACK, 1, :SPECIAL_ATTACK, 1]
  },
  "UserDealtCriticalHit_foe" => {
    "speech" => [:Ally, "Mmm, what a sexy hit!",
                 :Self, "Rad! Talk about bringin' a Water Gun to a Thunderbolt fight!"],
    "setBattler_A" => :Self,
    "battlerStats_A" => [:SPEED, 1],
    "setBattler_B" => :Ally,
    "battlerStats_B" => [:SPEED, 1]
  },
  "UserDealtCriticalHit_player" => {
    "speech" => [:Opposing, "Whozit?! A crit? No fair, {1}!"],
    "setBattler_A" => :Self,
    "battlerStats_A" => [:SPEED, 1],
    "setBattler_B" => :Ally,
    "battlerStats_B" => [:SPEED, 1]
  },
  "BattlerFainted_foe_repeat" => {
    "setSpeaker" => :SUPERNERD,
    "speech"     => ["NUH! MY QUEENS! YOU'LL PAY, BETA MALE! GO FORTH, WALLET! HELP M'LADIES!"],
    "setBattler_A" => :Opposing,
    "battlerStats_A" => [:ATTACK, -1, :SPECIAL_ATTACK, -1],
    "setBattler_B" => :OpposingAlly,
    "battlerStats_B" => [:ATTACK, -1, :SPECIAL_ATTACK, -1]
  },
  "AfterLastSwitchIn_player" => {
    "setSpeaker" => :BEAUTY,
    "speech" => ["I'm all about a comeback kid... Go get them, Challenger!"],
    "setBattler_A" => :Self,
    "battlerStats_A" => [:ATTACK, 1, :SPECIAL_ATTACK, 1, :DEFENSE, 1, :SPECIAL_DEFENSE, 1, :SPEED, 1, :ACCURACY, 1],
    "setBattler_B" => :Ally,
    "battlerStats_B" => [:ATTACK, 1, :SPECIAL_ATTACK, 1, :DEFENSE, 1, :SPECIAL_DEFENSE, 1, :SPEED, 1, :ACCURACY, 1]
  }
}

GYM4_MIDBATTLE   = {
  "RoundStartCommand_1_foe" => {
    "speech_A" => ["Hope you weren't planning on using WATER TYPES in here, bucko! My Fire Types will be cranking up the heat!"],
    "speech_B" => ["Only way to harsh our mellow is with the Ice Type... But I bet you don't have the guts to try that!"]
  },
  # Switching in Fire Type [+3]
  "AfterSendOut_FIRE_repeat" => { 
    "text" => "The temperature increased significantly!",
    "addVariable" => [3] 
  },
  # Switching in Fire Type [+3]
  "AfterSendOut_CASTFORM_foe" => { 
    "text" => "The temperature increased significantly!",
    "addVariable" => [3] 
  },
  # Switching in Ice Type [-3]
  "AfterSendOut_ICE_repeat" => { 
    "addVariable" => [-3],
    "text" => "The temperature dropped significantly!",
    "setBattler" => :Self,
    "battlerStats" => [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
  },
  # Using Ice Type Move [-2]
  "AfterMove_ICE_repeat" => { 
    "addVariable" => [-2],
    "text" => "The temperature dropped a couple notches!",
    "setBattler" => :Opposing,
    "battlerStats" => [:DEFENSE, -1, :SPECIAL_DEFENSE, -1, :SPEED, -1]
  },
  # Using Fire Type Move [+1]
  "AfterMove_FIRE_repeat" => { 
    "text" => "The temperature increased a little bit!",
    "addVariable" => [1] 
  },
  "VariableUnder_4" => { 
    "ignoreUntil" => "VariableOver_4",
    "setSpeaker" => :Hide,
    "editWindow" => "Temperature Gauge",
    "speech" => ["The temperature is Cool!"],
    "speech_B" => ["Water moves are at full power!"],
    "fieldEffects" => [:None]
  },
  "VariableOver_4" => { 
    "setSpeaker" => :Hide,
    "playAnim" => :SUNNYDAY,
    "editWindow" => "Temperature Gauge",
    "speech" => ["The temperature is Toasty!"],
    "speech_B" => ["Water moves are becoming weaker!"],
    "fieldEffects" => [:ToastyField, 10]
  },
  "BeforeMove_WATER_repeat" => { 
    "ignoreUntil" => "VariableOver_4",
    "ignoreAfter" => "VariableUnder_4",
    "battlerStats" => [:SPECIAL_ATTACK, -1, :ATTACK, -1]
  },
  "VariableUnder_8" => { 
    "ignoreUntil" => "VariableOver_8",
    "setSpeaker" => :Hide,
    "editWindow" => "Temperature Gauge",
    "speech" => ["The temperature is Toasty!"],
    "speech_B" => ["Water moves are becoming stronger again!"],
    "fieldEffects" => [:ToastyField, 10]
  },
  "VariableOver_8" => { 
    "setSpeaker" => :Hide,
    "playAnim" => :SUNNYDAY,
    "editWindow" => "Temperature Gauge",
    "speech" => ["It's getting hot in here!!"],
    "speech_B" => ["Water moves are almost useless!!"],
    "fieldEffects" => [:HotField, 10]
  },
  "BeforeMove_WATER_repeat" => { 
    "ignoreUntil" => "VariableOver_8",
    "ignoreAfter" => "VariableUnder_8",
    "battlerStats" => [:SPECIAL_ATTACK, -2, :ATTACK, -2]
  },
  "VariableUnder_12" => { 
    "ignoreUntil" => "VariableOver_12",
    "playAnim" => :SUNNYDAY,
    "editWindow" => "Temperature Gauge",
    "speech" => ["The temperature dropped a little bit."],
    "speech_B" => ["Water moves won't fizzle out anymore!"],
    "fieldEffects" => [:HotField, 10]
  },
  "VariableOver_12" => { 
    "setSpeaker" => :Hide,
    "playAnim" => :SUNNYDAY,
    "editWindow" => "Temperature Gauge",
    "speech" => ["Its unbearably hot!!"],
    "speech_B" => ["WATER MOVES WILL FIZZLE OUT!!"],
    "fieldEffects" => [:InfernoField, 10]
  },
  "BeforeMove_WATER_repeat" => { 
    "ignoreUntil" => "VariableOver_12",
    "ignoreAfter" => "VariableUnder_12",
    "battlerStats" => [:SPECIAL_ATTACK, -3, :ATTACK, -3],
    "battlerStatus" => :CONFUSED
  },
  "AfterLastSwitchIn_foe" => {
    "playAnim" => :TRICKROOM,
    "fieldEffects" => [:TrickRoom, 10, "The dimensions twisted!"]
  }
}

=begin
This is the old Gym 4 Midbattle script, featuring Field Conditions that FUCKING WORK BUT APPARENTLY CANNOT BE CALLED? FUCK ME. 
GYM4_MIDBATTLE   = {
  "RoundStartCommand_1_foe" => {
    "speech_A" => ["Hope you weren't planning on using WATER TYPES in here, bucko! My Fire Types will be cranking up the heat!"],
    "speech_B" => ["Only way to harsh our mellow is with the Ice Type... But I bet you don't have the guts to try that!"]
  },
  # Switching in Fire Type [+3]
  "AfterSendOut_FIRE_repeat" => { 
    "text" => "The temperature increased significantly!",
    "addVariable" => [3] 
  },
  # Switching in Fire Type [+3]
  "AfterSendOut_CASTFORM_foe" => { 
    "text" => "The temperature increased significantly!",
    "addVariable" => [3] 
  },
  # Switching in Ice Type [-3]
  "AfterSendOut_ICE_repeat" => { 
    "addVariable" => [-3],
    "text" => "The temperature dropped significantly!",
    "setBattler" => :Self,
    "battlerStats" => [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
  },
  # Using Ice Type Move [-2]
  "AfterMove_ICE_repeat" => { 
    "addVariable" => [-2],
    "text" => "The temperature dropped a couple notches!",
    "setBattler" => :Opposing,
    "battlerStats" => [:DEFENSE, -1, :SPECIAL_DEFENSE, -1, :SPEED, -1]
  },
  # Using Fire Type Move [+1]
  "AfterMove_FIRE_repeat" => { 
    "text" => "The temperature increased a little bit!",
    "addVariable" => [1] 
  },
  "VariableUnder_4" => { 
    "ignoreUntil" => "VariableOver_4",
    "setSpeaker" => :Hide,
    "editWindow" => "Temperature Gauge",
    "speech" => ["The temperature is Cool!"],
    "speech_B" => ["Water moves are at full power!"],
    "fieldEffects" => [:None]
  },
  "VariableOver_4" => { 
    "setSpeaker" => :Hide,
    "playAnim" => :SUNNYDAY,
    "editWindow" => "Temperature Gauge",
    "speech" => ["The temperature is Toasty!"],
    "speech_B" => ["Water moves are becoming weaker!"],
    "fieldEffects" => [:ToastyField, 10]
  },
  "BeforeMove_WATER_repeat" => { 
    "ignoreUntil" => "VariableOver_4",
    "ignoreAfter" => "VariableUnder_4",
    "battlerStats" => [:SPECIAL_ATTACK, -1, :ATTACK, -1]
  },
  "VariableUnder_8" => { 
    "ignoreUntil" => "VariableOver_8",
    "setSpeaker" => :Hide,
    "editWindow" => "Temperature Gauge",
    "speech" => ["The temperature is Toasty!"],
    "speech_B" => ["Water moves are becoming stronger again!"],
    "fieldEffects" => [:ToastyField, 10]
  },
  "VariableOver_8" => { 
    "setSpeaker" => :Hide,
    "playAnim" => :SUNNYDAY,
    "editWindow" => "Temperature Gauge",
    "speech" => ["It's getting hot in here!!"],
    "speech_B" => ["Water moves are almost useless!!"],
    "fieldEffects" => [:HotField, 10]
  },
  "BeforeMove_WATER_repeat" => { 
    "ignoreUntil" => "VariableOver_8",
    "ignoreAfter" => "VariableUnder_8",
    "battlerStats" => [:SPECIAL_ATTACK, -2, :ATTACK, -2]
  },
  "VariableUnder_12" => { 
    "ignoreUntil" => "VariableOver_12",
    "playAnim" => :SUNNYDAY,
    "editWindow" => "Temperature Gauge",
    "speech" => ["The temperature dropped a little bit."],
    "speech_B" => ["Water moves won't fizzle out anymore!"],
    "fieldEffects" => [:HotField, 10]
  },
  "VariableOver_12" => { 
    "setSpeaker" => :Hide,
    "playAnim" => :SUNNYDAY,
    "editWindow" => "Temperature Gauge",
    "speech" => ["Its unbearably hot!!"],
    "speech_B" => ["WATER MOVES WILL FIZZLE OUT!!"],
    "fieldEffects" => [:InfernoField, 10]
  },
  "BeforeMove_WATER_repeat" => { 
    "ignoreUntil" => "VariableOver_12",
    "ignoreAfter" => "VariableUnder_12",
    "battlerStats" => [:SPECIAL_ATTACK, -3, :ATTACK, -3],
    "battlerStatus" => :CONFUSED
  },
  "AfterLastSwitchIn_foe" => {
    "playAnim" => :TRICKROOM,
    "fieldEffects" => [:TrickRoom, 10, "The dimensions twisted!"]
  }
}
=end
GYM5_MIDBATTLE   = {
  # Regimimilk
  "RoundStartCommand_1_foe" => {  # Replace "MILTANKx" with whatever the ID for SG Miltank is. 
    "speech" => ["Alright! It's time for my ace in the hole!"],
    "battlerStats" => [:SPEED, -2],
    "text" => ["{1} can't get it going because of her Slow Start!"]
  },
  "BeforeStatusMove_foe" => {
    "ignoreAfter" => "Variable_3",
    "addVariable" => [1]
  },
  "Variable_1" => {
    "text" => ["{1} needs a drink!"],
    "battlerHP" => 20,
    "battlerStats" => [:SPEED, 1, :DEFENSE, 1]
  },
  "Variable_2" => {
    "text" => ["{1} is getting it together!"],
    "battlerHP" => 20,
    "battlerStats" => [:SPEED, 1, :DEFENSE, 1, :SPECIAL_DEFENSE, 1]
  },
  "Variable_3" => {
    "text" => ["{1} is ready!"],
    "battlerHP" => 20,
    "battlerStats" => [:SPEED, 1, :DEFENSE, 1, :SPECIAL_DEFENSE, 1],
    "battlerMoves" => [:ROLLOUT,nil,nil,nil],
    "battlerEffects" => [:Rollout, 3, "{1} is ready to rock and roll(out)!"]
  }
}


BANETTE_MIDBATTLE   = {
  # She big now.
  "RoundStartCommand_1_foe" => {
    "dynamax" => "Banette giggles... What's happening?!"
  }
}

ZOE_MIDBATTLE   = {
"RoundStartCommand_1_foe" => {
    "speech_A" => ["You will experence the might of Zoe, Grizzbolt, and the Rayne Syndicate!"],
	"changeTerrain" => :Electric,
	"teamEffects" => [:Chargestone, "There seems to be some kind of explosive ordnance!"],
	"battlerStats" => [:SPECIAL_ATTACK, 1, :DEFENSE, 2],
    "battlerHPCap" => 49,
	"text" => ["The hair on you arms are standing, Something Powerful is coming"]
	},
"RoundEnd_foe_repeat_even" => {
	"ignoreAfter"	=> "BattlerReachedHPCap_foe",
    "playSE"        => "Anim/Sound2",
    "battlerForm"   => [1, "{1} got the glock!"],
    "playCry"       => :Self,
	"battlerMoves" => [:EMBARGO, :TRIATTACK, :ARMORPIERCER, :NASTYPLOT],
    "battlerHP"     => [4, "{1} regenerated some HP!"]
  },
 "RoundEnd_foe_repeat_odd" => {
    "ignoreAfter"   => "BattlerReachedHPCap_foe",
    "playSE"        => "Anim/Sound2",
    "battlerForm"   => [0, "{1} Grizzbolt is ready!"],
    "playCry"       => :Self,
	"battlerMoves" => [:FLAMETHROWER, :WATERPULSE, :SHOCKWAVE, :ENERGYBALL],
    "battlerHP"     => [4, "{1} regenerated some HP!"]
  },
"BattlerReachedHPCap_foe" => {
    "speech_A" => ["Time to pull out all the stops!"],
	"playSE"        => "Anim/Sound2",
    "battlerForm"   => [2, "{1} Grizzbolt's gun is running!!"],
	"battlerMoves" => [:FLAMETHROWER, :HYDROSTEAM, :SHOCKWAVE, :GATLINGRUSH],
  },
"RoundEnd_foe" => {
    "ignoreUntil"   => "BattlerReachedHPCap_foe",
    "playCry"       => :Self,
    "battlerHP"     => [6, "{1} regenerated some HP!"]
  }
 }
 
DANCERFLYGON_MIDBATTLE = {
  "RoundStartCommand_1_foe" => {
    "setVariable" => 0,
    "changeWeather" => :Sandstorm,
    "battlerHPCap" => 49,
    "speech" => "The swaying of Flygon's wings whips up a sandstorm!",
    "text" => "Flygon's dance tempo begins to rise!",
    "addVariable" => 1
  },
  "UserMoveDodged_player_repeat" => {
    "setBattler" => :Opposing,
	"battlerHP" => -8,
    "setBattler" => :Opposing,
    "battlerStats" => [:SPEED, 1],
    "addVariable" => [1],
    "text" => ["Her tempo is increasing!"]
  },
  "UserDealtDamage_FLYGON_repeat" => {
    "text" => ["Her tempo is increasing!"],
	"setBattler_A" => :Opposing,
    "battlerHP_A" => -4,
    "setBattler_B" => :Opposing,
    "battlerHP_B" => [4, "{1} regenerated some HP!"],
    "addVariable" => [1]
  },
  "BattlerHPRecovered_foe" => {
	"setBattler" => :Self,
    "battlerStats" => [:EVASION, 1],
    "text" => ["Her tempo is increasing!"],
    "addVariable" => [1]
  },
  "UserMoveNegated_FLYGON_repeat" => {
    "text" => ["Her tempo is slowing down a bit!"],
	"addVariable" => [-1]
  },
  "UserMoveEffective_ICE" => {
    "text" => ["It hurts her tempo!!"],
	"addVariable" => [-2],
    "ignoreAfter" => "UserMoveEffective_ICE",
    "ignoreUntil" => "UserMoveEffective_ICE_repeat"
  },
  "UserMoveEffective_ICE_repeat" => {
    "ignoreUntil" => "UserMoveEffective_ICE",
    "text" => ["She adapted to keep her rhythm!"],
    "battlerHP" => -16
  },
  "UserMoveEffective_DRAGON" => {
    "text" => ["It hurts her tempo!!"],
	"addVariable" => [-1],
    "ignoreAfter" => "UserMoveEffective_DRAGON",
    "ignoreUntil" => "UserMoveEffective_DRAGON_repeat"
  },
  "UserMoveEffective_DRAGON_repeat" => {
    "ignoreUntil" => "UserMoveEffective_DRAGON",
    "text" => ["She adapted to keep her rhythm!"],
    "battlerHP" => -8,
    "battlerStats" => [:SPEED, -1]
  },
  "UserMoveEffective_FAIRY" => {
    "text" => ["It hurts her tempo!!"],
	"addVariable" => [-1],
    "ignoreAfter" => "UserMoveEffective_FAIRY",
    "ignoreUntil" => "UserMoveEffective_FAIRY_repeat"
  },
  "UserMoveEffective_FAIRY_repeat" => {
    "text" => ["She fights back!"],
    "ignoreUntil" => "UserMoveEffective_FAIRY",
    "battlerHP" => -8
  },
  "BattlerReachedHPCap_foe" => {
    "dynamax" => true,
    "speech" => "She's ready to put on a show!"
  }
}

PIPLUP_PRINPLUP_MIDBATTLE = {
  "RoundStartCommand_1_foe" => {
    "changeWeather" => :Rain,
	"setBattler" => :Opposing,
    "teamEffects" => [:StealthRock, true, "Pointed stones began to float around the field!"],
    "playSE" => "Anim/Rain"
  },
  "BattlerFainted_PIPLUP_foe" => {
    "setBattler" => :Opposing,
    "playSE" => "Anim/Heal",
    "battlerHP" => [25, "{1} got fired up and recovered some HP!"],
    "battlerStats" => [:ATTACK, -2, :DEFENSE, -1],
    "text" => ["{1} cries out in fury!"]
  },
  "BattlerFainted_PRINPLUP_foe" => {
    "setBattler" => :Opposing,
    "playSE" => "Anim/Heal",
    "battlerHP" => [25, "{1} got fired up and recovered some HP!"],
    "battlerStats" => [:SPECIAL_ATTACK, -2, :SPEED, -1],
    "text" => ["{1} cries out in fury!"]
  }
}

DONPOLEON_MIDBATTLE = {
  "RoundStartCommand_1_foe" => {
    "addWild" => [:PRINPLUPh_1, 45],
    "addVariable" => 1,
    "changeWeather" => :Rain,
	"battlerHPCap" => 49,
	"setBattler" => :Opposing,
    "teamEffects" => [:Spikes, 3, "{1} scatters vicious spikes across the field!"],
    "playSE" => "Anim/Rain",
    "text" => ["{1} glares at you menacingly!"]
  },
  "Variable_1" => {
    "addWild" => [:PIPLUPh_1, 40]
  },
  "VariableUp_repeat_every_2" => {
    "addWild" => [:PIPLUPh_1, 40],
	"setBattler" => :Ally,
	"battlerStats" => [:SPECIAL_ATTACK, 1]
  },
  "VariableUp_repeat_every_3" => {
    "addWild" => [:PRINPLUPh_1, 45],
	"setBattler" => :Ally2,
	"battlerStats" => [:SPECIAL_DEFENSE, 1]
  },
  "AfterSpecialMove_EMPOLEONsg_repeat_random_25" => {
    "setBattler" => :Ally,
    "battlerStats" => [:SPECIAL_DEFENSE, 1, :DEFENSE, 1],
    "text" => ["{1} steels its resolve!"],
    "playSE" => "Anim/CosmicPower",
	"addVariable" => 1
  },
  "BattlerFainted_foe_repeat" => {
	"setBattler" => :Opposing,
    "battlerStats" => [:ATTACK, -1, :SPECIAL_ATTACK, -1],
	"addVariable" => 1,
    "text" => ["{1} cries out in fury!"]
  },
  "BattlerReachedHPCap_foe" => {
    "dynamax" => true,
	"battlerStats" => [:ATTACK, 1, :SPECIAL_ATTACK, 1, :DEFENSE, 1, :SPECIAL_DEFENSE, 1],
    "text" => ["{1} towers over you, ready to crush all opposition!"]
  },
  "BattlerFainted_EMPOLEONsg" => {
    "speech"    => ["She dives into the water to escape!"],
    "endSpeech" => true,
    "endBattle" => 1
  }
}

MOTHERWAK_MIDBATTLE = {
"RoundStartCommand_1_foe" => {
    "speech_A" => ["Thank you for protecting me MotherWak, I'm sorry."],
	"battlerHPCap" => 49,
	"setBattler" => :Opposing,
	"teamEffects" => [:StealthRock, true, "{1} The ground obey's her motherly fury!"]
 },
"AfterPhysicalMove_player_repeat_random_25" => {
    "setBattler" => :Self, 
    "battlerStatus" => [:SLEEP, "{1} is hugged in a motherly embrace and falls asleep!"],
    "playSE" => "Anim/Heal"
},
"BattlerReachedHPCap_foe" => {
    "megaEvolve" => "You can feel her love, her anger, and all of her sorrow!",
	"battlerStats" => [:ATTACK, 1, :SPECIAL_ATTACK, 1, :DEFENSE, 1, :SPECIAL_DEFENSE, 1]
  }
 }

PDAWN_MIDBATTLE = {
"RoundStartCommand_1_foe" => {
    "speech_A" => ["We will take you down!"],
	"battlerHPCap" => 49,
	"setBattler" => :Opposing,
	"teamEffects" => [:Spikes, 3, "Dawn scatters vicious spikes across the field!"]
 },
 "BattlerStatLowered_DEFENCE_foe_repeat" => {
	"ignoreAfter" => "BattlerReachedHPCap_foe",
    "setBattler" => :Opposing,
	"battlerAbility" => :NORMALIZE,
    "addVariable" => 1,
    "text" => ["Dawn's spectral influence has altered {1} ability!"]
  },
"VariableUp_repeat_every_3" => {
    "setBattler" => :Self,
    "battlerStats" => [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
    "text" => ["{1}'s attack surges with her blistering speed!"],
    "setBattler" => :Opposing,
	"battlerStatus" => [:CONFUSION, true],
    "battlerStats" => [:ATTACK, -1, :DEFENSE, -1, :SPECIAL_ATTACK, -1, :SPECIAL_DEFENSE, -1, :SPEED, -1, :EVASION, -1]
  },
  "UserMoveEffective_CERULEDGEsg_foe" => {
    "setBattler" => :Opposing,
    "battlerEffects" => [:Curse, true, "Dawn haunts your Pokemon!"],
    "playSE" => "Anim/Glare"
  },
  "BattlerReachedHPCap_foe" => {
    "text" => ["{1}'s flame burns brightly!"],
	"battlerStats" => [:ATTACK, 1, :SPECIAL_ATTACK, 1, :DEFENSE, 1, :SPECIAL_DEFENSE, 1]
  }
 }
 
ABOMINEON_MIDBATTLE = {
"RoundStartCommand_1_foe" => {
    "dynamax" => false,
    "speech_A" => ["Thank you for protecting me MotherWak, I'm sorry."],
	"battlerHPCap" => 49,
	"setBattler" => :Opposing,
	"teamEffects" => [:StealthRock, true, "{1} The ground obey's her motherly fury!"]
 }
}

SERPERIOR_MIDBATTLE = {
  "RoundStartCommand_1_foe" => {
    "setBattler" => :Opposing,
    "changeTerrain" => :Grassy,
    "playSE" => "Anim/GrassyTerrain",
    "text" => ["Verdant grass surges across the battlefield, pulsing with life!"],
    "battlerHPCap" => 30
  },
  "TargetTookDamage_foe_repeat" => {
    "addVariable" => 1,
    "battlerEffects" => [:Stockpile, 1, "She's seems to be storing energy!"]
  },
  "VariableOver_3_repeat" => {
    "text" => ["{1} is ready!"],
    "battlerStats" => [:SPEED, 1, :DEFENSE, 3, :SPECIAL_DEFENSE, 3],
	"battlerMoves" => [:SPITUP,nil,nil,nil]
  },
  "AfterMove_SPITUP_repeat" => {
    "battlerMoves" => [:FLAMETHROWER, :SLUDGEWAVE, :ENERGYBALL, :MOONBLAST],
	"setVariable" => 0
  },
  "TargetHPHalf_foe" => {
    "ignoreAfter" => "TargetHPHalf_foe",
    "battlerHP" => [75, "{1} siphons life from the ancient roots!"],
    "battlerStats" => [:SPEED, 1, :DEFENSE, 2, :SPECIAL_ATTACK, 2, :SPECIAL_DEFENSE, 1],
    "playSE" => "Anim/Coil",
    "text" => ["{1} coils majestically, its body swelling with primal vigor!"]
  },
  "TargetHPLow_foe" => {
    "ignoreAfter" => "TargetHPLow_foe",
    "battlerHP" => [50, "{1} radiates an aura of unyielding dominance!"],
    "battlerStats" => [:SPECIAL_ATTACK, 1, :DEFENSE, 1, :SPEED, 2],
    "playSE" => "Anim/DragonDance",
    "text" => ["{1}'s fronds flare wildly as it prepares its final assault!"]
  },
  "BattlerReachedHPCap_foe" => {
    "dynamax" => true,
    "text" => ["{1} erupts with colossal energy!"],
    "playSE" => "Anim/MaxFlare" 
  }
}

LOPUNNY_MIDBATTLE = {
  "RoundStartCommand_1_foe" => {
    "setVariable" => 0,
	"battlerHPCap" => 49,
	"setBattler" => :Opposing,
    "teamEffects" => [:StealthRock, true, "Pointed stones float around the foe's party!"],
    "text" => ["{1} scattered pointed stones across the battlefield!"]
  },
  "BattlerStatRaised_SPEED_foe_repeat" => {
    "text" => ["{1}'s legs blur with blinding speed!"],
	"ignoreAfter" => "BattlerReachedHPCap_foe",
    "setBattler" => :Opposing,
    "battlerHP" => [-12, "{1} was struck by {2}'s swift kick!"],
    "addVariable" => 1,
    "text" => ["Lopunny gains momentum from her speed!"]
  },
  "VariableUp_repeat_every_3" => {
    "setBattler" => :Self,
    "battlerStats" => [:ATTACK, 2, :DEFENSE, 1, :SPECIAL_DEFENSE, 1, :SPEED, -1],
    "text" => ["{1}'s attack surges with her blistering speed!"],
    "setBattler" => :Opposing,
    "battlerStats" => [:ATTACK, -1, :DEFENSE, -1, :SPECIAL_ATTACK, -1, :SPECIAL_DEFENSE, -1, :SPEED, -1, :EVASION, -1],
    "text" => ["{1} is overwhelmed by Lopunny's flurry of kicks!"]
  },
  "BattlerReachedHPCap_foe" => {
    "ignoreAfter" => "TargetHPHalf_foe",
    "megaEvolve" => "{1} mega evolved in a burst of fierce determination!",
    "text" => ["Behold the ultimate evolution of speed and power!"]
  },
  "UserMoveEffective_player_repeat" => {
    "ignoreUntil" => "TargetHPHalf_foe",
    "text" => [:Opposing, "{1} flaming chains lashes out!"],
    "battlerStatus" => [:BURN, true]
  },
  "BattlerStatRaised_foe_repeat" => {
    "text" => ["{1}'s legs blur with blinding speed!"],
	"ignoreUntil" => "BattlerReachedHPCap_foe",
    "setBattler" => :Opposing,
    "battlerHP" => [-24, "{1} was struck by {2}'s swift kick!"],
    "addVariable" => 1,
    "text" => ["{1} gains momentum from her speed!"]
  },
}
 
HOUNDOOM_MIDBATTLE = {
"RoundStartCommand_1_foe" => {
    "setVariable" => 0,
	"battlerHPCap" => 50,
    "text" => ["{1} Seems to want to test your might!"]
  },
  "UserDealtDamage_foe_repeat" => {
    "addVariable" => 1,
	"text" => ["{1} is feeling herself!"]
  },
  "VariableUp_repeat_every_4" => {
    "setBattler"   => :Self,
    "battlerStats" => [:ATTACK, 1, :SPECIAL_DEFENSE, 1, :SPEED, 1],
    "text" => ["{1} is getting pumped up! She's landing hits left and right!"]
  },
   "UserMoveEffective_player_repeat" => {
    "text" => [:Opposing, "{1} unleashes a crippling howl!"],
    "battlerStatus" => [:PARALYSIS, true]
  },
  "BattlerReachedHPCap_foe" => {
    "megaEvolve" => "It seems that her most Primal instints have awaken!",
	"battlerStats" => [:ATTACK, 1, :SPEED, 1, :DEFENSE, 1, :SPECIAL_DEFENSE, 1],
	"battlerMoves" => [:FLAREBLITZ, :WICKEDBLOW, :DYNAMICPUNCH, :YAWN],
	"teamEffects" => [:StealthRock, true, "{1} Shards of the rock fly across the battle feild!"],
	"setVariable" => 0
  },
  "VariableUp_repeat_every_5" => {
    "ignoreUntil" => "BattlerReachedHPCap_foe",
	"battlerMoves" => [:DESTRUCTIONINTHREESTRIKES,nil,nil,nil],
	"battlerStats" => [:SPECIAL_DEFENSE, -1, :DEFENSE, -1]
  },
	"AfterMove_DESTRUCTIONINTHREESTRIKES_repeat" => {
    "battlerMoves" => [:FLAREBLITZ, :WICKEDBLOW, :DYNAMICPUNCH, :YAWN],
	"setVariable" => 0
  }
}

HOUNDOOM1_MIDBATTLE = {
"RoundStartCommand_1_foe" => {
    "setVariable" => 0,
	"battlerHPCap" => 75,
    "text" => ["{1} Seems to want to test your might!"]
  },
  "UserDealtDamage_foe_repeat" => {
    "addVariable" => 1,
	"text" => ["{1} is feeling herself!"]
  },
  "VariableUp_repeat_every_3" => {
    "setBattler"   => :Self,
    "battlerStats" => [:ATTACK, 1, :SPECIAL_ATTACK, 1, :SPEED, 1],
    "text" => ["{1} is getting pumped up! She's landing hits left and right!"]
  },
  "BattlerReachedHPCap_foe" => {
    "speech"    => ["She seems pleased with the battle."],
    "endSpeech" => true,
    "endBattle" => 1
  }
}

ABSOL_MIDBATTLE = {
"RoundStartCommand_1_foe" => {
    "setVariable" => 0,
	"battlerHPCap" => 50,
    "text" => ["{1} doesn't want to battle"]
  },
  "UserDealtDamage_foe_repeat" => {
    "addVariable" => 1,
	"text" => ["{1} she's trying to keep a keep up!"]
  },
  "VariableUp_repeat_every_3" => {
    "setBattler"   => :Self,
    "battlerStats" => [:ATTACK, 1, :SPEED, 1],
    "text" => ["{1} pushing her limits!"]
  },
  "BattlerReachedHPCap_foe" => {
    "battlerForm"   => [1, "{1} whales as she unleashed her love, her anger, and all of her sorrow!"],
	"battlerStats" => [:ATTACK, 1, :DEFENSE, 1, :SPEED, 1]
  }
}

MAY_MIDBATTLE = {
"AfterSendOut_foe_repeat" => {
    "addVariable" => 1
    },
"Variable_1" => {
    "battlerStats" => [:ATTACK, 1]
    },
"Variable_2" => {
    "battlerStats" => [:DEFENSE, 1]
    },
"Variable_3" => {
    "battlerStats" => [:SPEED, 1]
    },
"Variable_4" => {
    "battlerStats" => [:SPECIAL_ATTACK, 1]
    },
"Variable_5" => {
    "battlerStats" => [:SPECIAL_DEFENSE, 1]
    },
"Variable_6" => {
    "battlerStats" => [:EVASION, 1]
    }
  }

BRAIXEN_MAGI_MIDBATTLE = {
  "RoundStartCommand_1_foe" => {
    "addWild" => [:FENNEKIN_2, 30],
    "addVariable" => 1,
    "battlerHPCap" => 49,
    "changeTerrain" => :Psychic,
    "playSE" => "Anim/Psychic",
    "text" => ["{1} summons her first magical familiar!"]
  },
  "Variable_1" => {
    "addWild" => [:FENNEKIN, 30],
    "text" => ["Another familiar appears to aid {1}!"]
  },
  "TargetTookDamage_foe" => {
    "ignoreAfter" => "Variable_2",
    "battlerHP" => [15, "{1} is shielded by her familiars!"],
    "text" => ["The familiars absorb some of the damage!"],
    "playSE" => "Anim/Protect"
  },
  "BattlerFainted_FENNEKIN_2" => {
    "text" => ["Brax! Braxien!"],
    "setBattler" => :Opposing,
    "battlerStats" => [:SPECIAL_ATTACK, 1, :SPEED, 1],
    "addVariable" => 1,
    "playSE" => "Anim/Flamethrower"
  },
  "BattlerFainted_FENNEKIN" => {
    "text" => ["Brax! Braxien!"],
    "setBattler" => :Opposing,
    "battlerStats" => [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
    "addVariable" => 1,
    "playSE" => "Anim/Flamethrower"
  },
  "BattlerReachedHPCap_foe" => {
    "dynamax" => true,
    "text" => ["{1} towers above, radiating mystical flames!"]
  }
}

BRAIXEN_MAGI_MIDBATTLE1 = {
  "RoundStartCommand_1_foe" => {
    "addWild" => [:FENNEKIN_2, 30],
    "addVariable" => 1,
    "battlerHPCap" => 49,
    "changeTerrain" => :Psychic,
    "playSE" => "Anim/Psychic",
    "text" => ["{1} summons her first magical familiar!"]
  },
  "Variable_1" => {
    "addWild" => [:ABSOL_2, 35],
    "text" => ["She is being called to aid {1}!"]
  },
  "TargetTookDamage_foe" => {
    "ignoreAfter" => "Variable_2",
    "battlerHP" => [15, "{1} is shielded by her familiars!"],
    "text" => ["The familiars absorb some of the damage!"],
    "playSE" => "Anim/Protect"
  },
  "BattlerFainted_FENNEKIN_2" => {
    "text" => ["Brax! Braxien!"],
    "setBattler" => 1,
    "battlerStats" => [:SPECIAL_ATTACK, 1, :SPEED, 1],
    "addVariable" => 1,
    "playSE" => "Anim/Flamethrower"
  },
  "BattlerFainted_ABSOL_2" => {
    "text" => ["Brax! Braxien!"],
    "setBattler" => 1,
    "battlerStats" => [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
    "addVariable" => 1,
    "playSE" => "Anim/Flamethrower"
  },
  "BattlerReachedHPCap_foe" => {
    "dynamax" => true,
    "text" => ["{1} towers above, radiating mystical flames!"]
  }
}
#===============================================
#
# MDH MIDBATTLE SCRIPTS!
#
#===============================================
DAIYOUSEI_MIDBATTLE = {
  "RoundStartCommand_1_foe" => {
    "setVariable"   => 0,
    "changeTerrain" => :Misty,
    "changeWeather" => :Rain,
    "speech" => ["U-um... P-please go easy on me..."]
  },
  "AfterSendOut_ALTARIA" => {
	"battlerEffects" => [:Reflect, 5],
	"playSE" => "Spellactive",
    "speech"       => ["Spell Card ~ Gentle Breeze of Healing Petals ~"],
    "battlerStats" => [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
  },
  "AfterSendOut_RIBOMBEE" => {
    "battlerStats" => [:SPECIAL_ATTACK, 1, :SPEED, 1],
    "battlerEffects" => [:Safeguard, 1],
    "speech"       => ["Spell Card ~ Shimmering Fairy Bullet Dance ~"]
  },
  "AfterSendOut_EMOLGA" => {
    "battlerStats" => [:SPEED, 2, :EVASION, 1],
    "battlerEffects" => [:LightScreen, 4],
    "speech"       => ["Spell Card ~ Lightning Fairy Escape Maneuver ~"]
  },
  "AfterSendOut_TROPIUS" => {
    "battlerStats" => [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
    "battlerEffects" => [:Ingrain],
    "speech"       => ["Spell Card ~ Tropical Sanctuary of Fairy Rain ~"]
  },
  "AfterSendOut_TOGEKISS" => {
    "battlerStats" => [:SPECIAL_DEFENSE, 2, :SPEED, 1],
    "teamEffects" => [:Tailwind, 5],
    "speech"       => ["Spell Card ~ Wish Upon a Shy Fairy Star ~"]
  },
 "AfterSendOut_DAIYOUSEI" => {
    "battlerStats" => [:SPECIAL_DEFENSE, 3, :DEFENSE, 3],
    "battlerEffects" => [:Tailwind,5],
    "speech"       => ["S-Spell Card... ~ Tiny Starlight of Hope ~"]
    }
}

RATTATAm_MIDBATTLE = {
  "RoundStartCommand_1_foe" => {
    "addWild" => [:RATTATAm, 40],
    "addVariable" => 1,
    "battlerHPCap" => 49,
    "playSE" => "Anim/Rain",
    "text" => ["{1} glares at you menacingly!"]
  },
  "Variable_1" => {
    "addWild" => [:RATTATAm, 40]
  }
 }
 
InesseBFFTrainers_MIDBATTLE = {
  "RoundStartCommand_1_foe" => {
    "speech"   => ["Get ready for battle, you scarred mutt!"],
    "setVariable" => 1
 },
  "Variable_1" => {
   "addWild" => [:ABSOLx, 30],
   "text" => ["This Pokemon slowly walks into battle!"]
 }
}

LEAFEON_BOSS = {
  "RoundStartCommand_1_foe" => {
    "setVariable" => 0,
    "battlerForm" => [1, "Leafeon has formed a shell around herself!"],
    "battlerHPCap" => 100,
    "playSE" => "Anim/GrassyTerrain",
    "text" => "The tree form shrugs off all attacks!"
  },
  "TargetTookDamage_foe_repeat" => {
    "ignoreAfter" => "Variable_6",
    "addVariable" => 1,
    "battlerHP" => [100, "The ancient tree absorbs the blow into its bark!"],
    "playAnim" => [:WOODHAMMER, :Opposing, :Self],
    "playSE" => "Anim/BulletSeed"
  },
  "Variable_3" => {
    "battlerForm" => [2, "Cracks spiderweb across the tree bark!"],
    "playSE" => "Mining collapse",
    "text" => "The tree trembles!"
  },
  "Variable_6" => {
    "battlerForm" => [0, "The tree shatters spectacularly!"],
    "battlerHPCap" => -1,
    "changeWeather" => :Rain,
    "battlerStats" => [:DEFENSE, 3, :SPECIAL_DEFENSE, 3],
    "speech" => ["Leafeon emerges!\nThe rain nourishes her!"],
    "playSE" => "Anim/Rain",
    "text" => "Leafeon is empowered by the downpour!"
  },
  "RoundEnd_foe_repeat" => {
    "ignoreUntil" => "Variable_6",
    "ignoreAfter" => "TargetHPHalf_foe",
    "battlerHP" => [12, "{1} draws vitality from the rain!"]
  },
  "TargetHPHalf_foe" => {
    "ignoreUntil" => "Variable_6",
    "battlerHP" => [100, "Leafeon melds back into the tree!"],
    "battlerForm" => [1, "The shattered tree miraculously reforms!"],
    "battlerHPCap" => 100,
    "playSE" => "Anim/GrassyTerrain",
    "text" => "The guardian endures!"
  },
  "Variable_3" => {
	"ignoreUntil" => "TargetHPHalf_foe",
    "battlerForm" => [2, "Cracks spiderweb across the tree bark!"],
    "playSE" => "Mining collapse",
    "text" => "The tree trembles!"
  },
  "Variable_6" => {
	"ignoreUntil" => "TargetHPHalf_foe",
    "battlerForm" => [0, "The tree shatters spectacularly!"],
    "battlerHPCap" => -1,
    "changeWeather" => :Rain,
	"battlerMoves" => [:DEFENSECURL,nil,nil,nil],
    "battlerStats" => [:DEFENSE, -6, :SPECIAL_DEFENSE, -6, :ATTACK, -6, :SPEED, -6, :SPECIAL_ATTACK, -6],
    "speech" => ["Leafeon emerges!\nThe rain nourishes her!"],
    "playSE" => "Anim/Rain",
    "text" => "Leafeon doesn't want to battle."
  }
}

ABOMINACEON_INTRO_MIDBATTLE = {
  "RoundStartCommand_1_foe" => {
    "setVariable"   => 0,
    "setChoices"    => [:Gen1, nil, {
      "Fire Core"   => "You take aim for the Fire Core!",
      "Water Core"  => "You take aim for the Water Core!",
      "Electric Core"  => "You take aim for the Electric Core!"
    }],
    "speech"        => ["Abominaceon pulses with elemental power!\nWhich core will you strike?", :Choices]
  },
  # Phase 1 Choices
  "Choice_Gen1_1" => { # Fire
	"changeWeather" => :Sun,
    "battlerStats" => [:ATTACK, 2, :SPEED, 2, :SPECIAL_DEFENSE, 1, :DEFENSE, 1],
	"battlerMoves" => [:RAGINGFURY, :EARTHQUAKE, :SOLARBLADE, :DRAGONDANCE],
    "battlerForm" => 1,
    "text"         => "You targeted the Fire part!"
  },
  "Choice_Gen1_2" => { # Water
	"changeWeather" => :Rain,
    "battlerStats" => [:ATTACK, 1, :SPEED, 2, :SPECIAL_DEFENSE, 2, :DEFENSE, 1],
	"battlerMoves" => [:WEATHERBALL, :SCALD, :HURRICANE, :NASTYPLOT],
    "battlerForm" => 2,
    "text"         => "You targeted the Water part!"
  },
  "Choice_Gen1_3" => { # Electric
	"changeTerrain" => :Electric,
    "battlerStats" => [:SPECIAL_ATTACK, 1, :SPEED, 3, :ATTACK, 1],
	"battlerMoves" => [:PSYBLADE, :THUNDERCAGE, :NORETREAT, :THUNDERBOLT],
    "battlerForm" => 3,
    "text"         => "You targeted the electric part!"
  },
  "BeforeStatusMove_foe_repeat" => {
    "addVariable" => 1,
    "setBattler" => :Opposing,
	"battlerHP" => -8,
	"text" => ["{1} sees you're lack of aggregation as an opening!"]
  }
}

ABOMINACEON_MIDBATTLE = {
  "RoundStartCommand_1_foe" => {
    "changeTerrain" => :Electric,
    "setVariable"   => 0,
    "playSE"        => "Anim/ElectricTerrain",
    "text"          => "Electric Terrain crackles to life!",
    "setChoices"    => [:Gen1, nil, {
      "Fire Core"   => "You take aim for the Fire Core!",
      "Water Core"  => "You take aim for the Water Core!",
      "Electric Core"  => "You take aim for the Electric Core!"
    }],
    "speech"        => ["Abominaceon pulses with elemental power!\nWhich core will you strike?", :Choices]
  },

  # Phase 1 Choices
  "Choice_Gen1_1" => { # Fire
    "changeWeather" => :Sun,
    "battlerStats" => [:ATTACK, 2, :SPEED, 2],
    "battlerForm" => 1
  },
  "Choice_Gen1_2" => { # Water
    "changeWeather" => :Rain,
    "battlerStats" => [:SPECIAL_DEFENSE, 2, :SPEED, 2],
    "battlerForm" => 2
  },
  "Choice_Gen1_3" => { # Electric
    "changeTerrain" => :Electric,
    "battlerStats" => [:DEFENSE, 2, :SPEED, 2],
    "battlerForm" => 3
    },
  # After Phase 1 "faint" (revive to Phase 2)
  "BattlerHPCritical_foe" => {
    "ignoreUntil" => "Variable_0",
    "ignoreAfter" => "Variable_1",
    "battlerHP"   => [100, "{1} revives with a new fusion!"],
    "battlerStatus" => :NONE,
    "addVariable" => 1,
    "battlerForm" => [4, "The shadowed fusion awakens!"],
    "changeTerrain" => :Psychic,
    "setChoices"  => [:phase2, nil, {
      "Psychic Core" => "The psychic glow dims to nothing!",
      "Dark Core"    => "Shadows recede from the Dark core!"
    }],
    "speech"      => ["The fusion grows darker!\nWhich core will you strike next?", :Choices]
  },

  "Choice_phase2_1" => { # Psychic
    "battlerStats" => [:SPECIAL_ATTACK, 2],
    "battlerForm"  => [5, "Psychic core destroyed!"],
    "text"         => "You pierced the Psychic part!"
  },
  "Choice_phase2_2" => { # Dark
    "battlerStats" => [:DEFENSE, 2],
    "battlerForm"  => [6, "Dark core destroyed!"],
    "text"         => "You smashed the Dark part!"
  },

  # After Phase 2 "faint" (revive to Phase 3)
  "BattlerHPCritical_foe" => {
    "ignoreUntil" => "Variable_1",
    "ignoreAfter" => "Variable_2",
    "battlerHP"   => [100, "{1} revives with a new fusion!"],
    "battlerStatus" => :NONE,
    "addVariable" => 1,
    "battlerForm" => [6, "The fusion grows wild and cold!"],
    "setChoices"  => [:phase3, nil, {
      "Grass Core" => "Vines wither and decay!",
      "Ice Core"   => "The icy shards melt into steam!"
    }],
    "speech"      => ["The fusion grows wilder and colder!\nWhich core will you strike?", :Choices]
  },

  "Choice_phase3_1" => { # Grass
    "battlerStats" => [:DEFENSE, 1, :SPECIAL_DEFENSE, 1],
    "battlerForm"  => [7, "Grass core destroyed!"],
    "text"         => "You withered the Grass part!"
  },
  "Choice_phase3_2" => { # Ice
    "battlerStats" => [:EVASION, 2],
    "battlerForm"  => [8, "Ice core destroyed!"],
    "text"         => "You melted the Ice part!"
  },

  # After Phase 3 "faint" (revive to Phase 4)
  "BattlerHPCritical_foe" => {
    "ignoreUntil" => "Variable_2",
    "ignoreAfter" => "Variable_3",
    "battlerHP"   => [100, "{1} revives with a new fusion!"],
    "battlerStatus" => :NONE,
    "addVariable" => 1,
    "battlerForm" => [8, "The final ethereal fusion appears!"],
    "setChoices"  => [:phase4, nil, {
      "Fairy Core" => "Fairy sparkles shatter like glass!",
      "Ghost Core" => "The ghostly essence fades!"
    }],
    "speech"      => ["The final fusion is almost broken!\nWhich core will you strike?", :Choices]
  },

  "Choice_phase4_1" => { # Fairy
    "battlerStats" => [:SPECIAL_DEFENSE, 2],
    "battlerForm"  => [9, "Fairy core destroyed!"],
    "text"         => "You pierced the Fairy part!"
  },
  "Choice_phase4_2" => { # Ghost
    "battlerStats" => [:ATTACK, 2],
    "battlerForm"  => [9, "Ghost core destroyed!"],
    "text"         => "You banished the Ghost part!"
  },

  # After Phase 4 "faint" (revive to final normal form, no more revival after this)
  "BattlerHPCritical_foe" => {
    "ignoreUntil" => "Variable_3",
    "ignoreAfter" => "Variable_4",
    "battlerHP"   => [100, "{1} revives in her normal form for the final battle!"],
    "battlerStatus" => :NONE,
    "addVariable" => 1,
    "battlerForm" => [0, "All cores collapse! Abominaceon unravels!"],
    "playAnim"    => [:PLAYROUGH, :Opposing, :Self],
    "playSE"      => "Anim/PlayRough",
    "text"        => "The final fusion unravels! She is vulnerable now!"
  },

  # True final desperate stand (only in final form)
  "BattlerHPCritical_foe" => {
    "ignoreUntil" => "Variable_4",
    "battlerHP"   => [50, "{1} draws on lingering chaos!"],
    "battlerStats" => [:ATTACK, 1, :SPECIAL_ATTACK, 1, :SPEED, 1]
  }
}

HERO_DUO_MIDBATTLE = {
  "RoundStartCommand_1_foe" => {
    "setVariable"   => 0,
    "battlerForm"   => [1, "The heroic duo stands ready!"],
    "changeTerrain" => :Electric,
	"battlerHPCap" => 49,
    "battlerStats"  => [:SPEED, 2, :EVASION, 1, :SPECIAL_ATTACK, 1],
    "playSE"        => "Anim/Charge",
    "playAnim"      => [:BULKUP, :Self],
    "text"          => "The twin heroes strike a synchronized pose !"
  },
  "TargetTookDamage_foe_repeat" => {
    "ignoreAfter" => "TargetHPHalf_foe",
    "addVariable" => 1,
    "text"        => "Their heroic bond lets them shrug off the pain together!",
    "battlerHP"   => [-4]
  },
  "Variable_repeat_every_3" => {
    "text"         => "Synchronized heroic strike!",
    "playSE"       => "Anim/Discharge",
    "playAnim"     => [:FUSIONFLARE, :Self],
    "battlerStats" => [:ATTACK, 1, :SPECIAL_ATTACK, 1]
  },
   "BattlerStatusCured_foe" => {
    "text"         => "They take this as an opening!",
	"setBattler" => :Opposing,
	"battlerStats" => [:ATTACK, -1, :SPECIAL_ATTACK, -1, :SPECIAL_DEFENSE, -2]	
  },
  "BattlerReachedHPCap_foe" => {
    "text"          => "Heroic energy surges through their shared core!",
    "battlerHP"     => [40],
    "battlerStats"  => [:SPECIAL_DEFENSE, 2, :SPEED, 1],
    "playSE"        => "Anim/Recover"
  },
  "BattlerHPCritical_foe" => {
    "changeBackdrop" => "city_night",
    "battlerHP"      => [60],
    "battlerStats"   => [:ATTACK, 2, :SPECIAL_ATTACK, 2, :SPEED, 2],
    "playSE"         => "Anim/MaxLightning",
    "playCry"        => :Self
  }
}
#===============================================
#
# Professional's MIDBATTLE SCRIPTS!
#
#===============================================

#Eevee Boss Fight
EEVEE_MIDBATTLE   = {
  "TargetTookDamage_foe_repeat" => {
    "ignoreAfter" => "BattlerReachedHPCap_foe",
    "text" => "{1} stares a you defiant!",
    "battlerHPCap" => 40
  },
  "BattlerReachedHPCap_foe" => {
	"ignoreAfter" => "BattlerHPCritical_foe",
	"text_A" => "{1} looks weakened for a moment, she shakes her head and gets back to the battle",
	"battlerHPCap" => 0
  },
  "RoundEnd_foe_repeat" => {
    "ignoreUntil" => "BattlerHPCritical_foe",
    "setVariable" => 0, 
    "addVariable" => [1,2,3]
  },
  "BattlerHPCritical_foe" => {
    "text_A" => "Eevee resist don't wanting to lose against you",
    "playAnim" => [:BULKUP, :Self],
    "playCry" => :Self,
    "battlerHP" => [25, "{1} Recover some health and gather all her strenght as a last effort!"],
    "battlerStats" => [:ATTACK, 6, :DEFENSE, 1, :SPEED, 2, :SPECIAL_DEFENSE, 1, :SPECIAL_ATTACK, 6],
  },
  "Variable_1_repeat" => {
	"playCry" => :Self,
	"text_A" => "Eevee throws at you some items!",
	"setBattler_A" => :Opposing,
	"battlerHP" => -8,
	"battlerStats_A" => [:Random, 1, :Random, -1]
  },
  "Variable_2_repeat" => {
	"text" => "Eevee shouts loudly!",
	"setBattler_A" => :Opposing,
	"battlerStats" => [:ATTACK, -1, :DEFENSE, -1]
  },
  "Variable_3_repeat" => { 
	"text" => "Eevee takes a bite of a berry",
	"battlerHP" => 5
  }
}
end