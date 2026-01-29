MultipleForms.register(:GROWLITHE_3, {
  "getForm" => proc { |pkmn|
    next 1 if pkmn.hasItem?(:HOOKSWORD)
    next 0
  }
})