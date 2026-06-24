module GameData
  class Trainer
    SUB_SCHEMA["Innates"] = [:Innates, "*e", :Ability]

    alias innate_abilities_to_trainer to_trainer
    def to_trainer
      trainer = innate_abilities_to_trainer
      trainer.party.each_with_index do |pkmn, i|
        if @pokemon[i][:Innates].is_a?(Array)
          pkmn.clear_innates  # Optional: clear existing innates if needed
          @pokemon[i][:Innates].each do |innate|
            pkmn.add_innate(innate)
          end
        end
        #puts "Assigned Innates to #{pkmn.name}: #{pkmn.Innates.inspect}"  # Debug log
        pkmn.calc_stats
      end
      return trainer
    end
  end
end