#===============================================================================
# Settings
#===============================================================================
module Settings
  # Set to true if you want to have to start the lock system. This allows you to lock the pokemon's innates with various methods.
  # If set to false, all innates will be available from the start.
  # Default: False
  INNATE_LOCKED_SYSTEM = false

  # Define wich game switch can be used to turn the locked system on or off. This is useful if you want to have the locked system active only in certain difficulties or what not.
  # If set to -1, the system will rely entirely on the INNATE_LOCKED_SYSTEM setting.
  # Keep in mind, the switch depends on the INNATE_LOCKED_SYSTEM being true. If the system is false, the switch will do nothing. It's just a secondary toggle.
  INNATE_LOCKED_SYSTEM_SWITCH = -1
  
  # Choose the progression style:
  # :variable -> Each pokemon will have innates unlocked up to the amount given by the INNATE_PROGRESS_VARIABLE. This affects every Pokemon.
  # :level    -> Each pokemon will have their innates unlocked depending on their level and the LEVELS_TO_UNLOCK array defined below.
  # :none     -> Each pokemon will have their innates locked and can only unlocke them by increasing their unlocked_innate_count property.
  INNATE_LOCKED_METHOD = :none

  # Define witch variable can be used to toogle the lock method. If set to -1, the method will be defined by the INNATE_LOCKED_METHOD setting.
  # If a variable is set (meaning any value greater than 0), the method will depend on that game variable's value: 0 = :none, 1 = :level, 2 = :variable.
  INNATE_LOCKED_METHOD_VARIABLE = -1
  INNATE_PROGRESS_VARIABLE = -1 #Only used for the :variable method. Defines the variable that will control the unlocking of innates.

  # Set this true if you want only the player's pokemon to be affected by the locked innate system. 
  # Since the lock happens after sending a pokemon to battle, wild pokemon will have all of their innates, but upon capturing and seeing their summary or sending them,
  # they'll have their innates locked until you unlock them.
  ONLY_LOCK_PLAYER = false

  # Define a switch to toggle the "only lock player" mode on or off. If set to -1, the "only lock player" mode will be always on or off depending on the ONLY_LOCK_PLAYER setting.
  ONLY_LOCK_PLAYER_SWITCH = -1
  
  #-----------------------------------------------------------------------------
  # You can define a species' specific level-innate progression with the array. Each value represents an innate they can get.
  # Dont use more values than the maximum amount of innates a pokemon can have.
  # In this example, all pokemon have 3 innates, and all pokemon but Mewtwo, Arceus and Buterfree will have their innates unlocked at levels 1, 15 and 45.
  # Mewtwo will have them unlocked at levels 45, 70 and 90. Arceus at levels 80, 90 and 100. Butterfree at levels 10, 14 and 30.
  # LEVELS_TO_UNLOCK =  [
  # [:MEWTWO, 45, 70, 90],
  # [:ARCEUS, 80, 90, 100],
  # [:BUTTERFREE, 10, 14, 30],
  # [1, 15, 45]
  # ]
  #-----------------------------------------------------------------------------
  LEVELS_TO_UNLOCK = [
    [1, 15, 45]
  ]

  #-----------------------------------------------------------------------------
  #With the following settings you can give pokemon a bigger pool a set of "random" innates.
  #The way it works is, from the available innates a pokemon has, randomly grab an X amount of innates from that list.
  #And use those X innates to be the active innates a pokemon has. 
  #The amount can be defined with the INNATE_MAX_AMOUNT setting.
  #Keep in mind, having this setting off will simply load ALL of the innates defined in each pokemon's "Innates =" section of the PBS.
  #-----------------------------------------------------------------------------
  
  #-----------------------------------------------------------------------------
  #Set to true if you want to enable the "Random Innate Selection"
  #-----------------------------------------------------------------------------
  INNATE_RANDOMIZER = false

  #-----------------------------------------------------------------------------
  # #Define a switch to toggle the randomizer on or off. If set to -1, the randomizer will be always on or off depending on the INNATE_RANDOMIZER setting.
  #-----------------------------------------------------------------------------
  INNATE_RANDOMIZER_SWITCH = -1
  
  #-----------------------------------------------------------------------------
  #Maximunt amount of innates a pokemon can grab from it's innates.
  #-----------------------------------------------------------------------------
  INNATE_MAX_AMOUNT = 6

  #-----------------------------------------------------------------------------
  #Define a variable to control the amount of innates a pokemon can have. If set to -1, the amount will be defined by the INNATE_MAX_AMOUNT setting.
  #-----------------------------------------------------------------------------
  INNATE_AMOUNT_VARIABLE = -1
  
  #-----------------------------------------------------------------------------
  #Se to true if you want the randomizer to grab abilities from all existing abilities in the game
  #Requires the INNATE_RANDOMIZER to be true (And it's switch if defined) and a set amount in the INNATE_MAX_AMOUNT setting (Or variable if defined)
  #-----------------------------------------------------------------------------
  MAX_INNATE_RANDOMIZER = false

  #-----------------------------------------------------------------------------
  #Define a switch to toggle the max innate randomizer on or off. If set to -1, the max innate randomizer will be always on or off depending on the MAX_INNATE_RANDOMIZER setting.
  #-----------------------------------------------------------------------------
  MAX_INNATE_RANDOMIZRER_SWITCH = -1
  
  #-----------------------------------------------------------------------------
  #Set the ID list of all abilities that can never be grabed by the max innate randomizer.
  # Example: [:NOABILITY, :WONDERGUARD, :MUMMY]
  #-----------------------------------------------------------------------------
  BLACKLIST = [:NOABILITY]
  
  #-----------------------------------------------------------------------------
  #Set to true if you want to randomize innates even if they are less than the given maximum.
  #Basically having them in a random order. Pairs well with the progresss settings for a surprise progress per pokemon.
  #-----------------------------------------------------------------------------
  ALWAYS_SHUFFLE_RANDOMS = false

  #-----------------------------------------------------------------------------
  #Define a switch to toggle the always shuffle randoms on or off. If set to -1, the always shuffle randoms will be always on or off depending on the ALWAYS_SHUFFLE_RANDOMS setting.
  #-----------------------------------------------------------------------------
  ALWAYS_SHUFFLE_RANDOMS_SWITCH = -1
	
  #Personal setting. I like to use small fonts for my abilities. Ignore this one.
  SMALL_FONT_IN_SUMMARY = true
end  