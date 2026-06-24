#===============================================================================
# Instances of this class are individual Pokémon.
# The player's party Pokémon are stored in the array $player.party.
#===============================================================================
=begin
class Pokemon
  attr_accessor :abilityMutation

	################################################################################
	# All Abilities Mutation
	################################################################################ 
	# Enables All Abilities Mutation.
	  @abilityMutation = false
	  def enableAbilityMutation
		@abilityMutation = true
	  end  
	# Disables All Abilities Mutation.
	  def disableAbilityMutation
		@abilityMutation = false
	  end    

	# Toggles All Abilities Mutation.
	  def toggleAbilityMutation
		if !@abilityMutation
			@abilityMutation = true
		else	
			@abilityMutation = false
		end	
	  end 		
		
	  def hasAbilityMutation?
		if @abilityMutation==true
			return true 
		end	
	  end
end
=end
class Pokemon
  attr_accessor :abilityMutation

  alias innate_init initialize
  def initialize(*args)
    innate_init(*args)
    @abilityMutation = true 
  end

  def hasAbilityMutation?
    return true
  end
end