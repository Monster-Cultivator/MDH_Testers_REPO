MultipleForms.register(:GROWLITHE_3, {
  "getForm" => proc { |pkmn|
    next 2 if pkmn.hasItem?(:HOOKSWORD)
    next 0
  }
})
