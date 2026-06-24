#===============================================================================
# Battle Info UI
#===============================================================================
class Game_Temp
  attr_accessor :battle_info_pending_boss_immunities if !method_defined?(:battle_info_pending_boss_immunities)
end if defined?(Game_Temp)

module BattleInfoBossImmunityCapture
  def self.capture(rule, args)
    return if !defined?($game_temp) || !$game_temp
    return if !$game_temp.respond_to?(:battle_info_pending_boss_immunities=)
    rule_name = rule.to_s
    return if !rule_name[/\AeditWildPokemon(\d*)\z/i]
    slot_text = $1.to_s
    slot = slot_text.empty? ? 0 : [slot_text.to_i - 1, 0].max
    attrs = args.find { |arg| arg.is_a?(Hash) }
    raw_immunities = nil
    raw_immunities = attrs[:immunities] || attrs["immunities"] if attrs
    $game_temp.battle_info_pending_boss_immunities ||= {}
    if raw_immunities.nil? || (raw_immunities.respond_to?(:empty?) && raw_immunities.empty?)
      $game_temp.battle_info_pending_boss_immunities.delete(slot)
    else
      $game_temp.battle_info_pending_boss_immunities[slot] = raw_immunities.clone rescue raw_immunities
    end
  rescue
  end
end

class Battle
  attr_accessor :battle_info_boss_immunities if !method_defined?(:battle_info_boss_immunities)

  unless method_defined?(:battle_info_immunity_capture_initialize)
    alias battle_info_immunity_capture_initialize initialize

    def initialize(*args)
      pending_immunities = {}
      begin
        if defined?($game_temp) && $game_temp &&
           $game_temp.respond_to?(:battle_info_pending_boss_immunities)
          raw_pending = $game_temp.battle_info_pending_boss_immunities || {}
          pending_immunities = Marshal.load(Marshal.dump(raw_pending)) rescue raw_pending.clone rescue raw_pending
        end
      rescue
        pending_immunities = {}
      end
      battle_info_immunity_capture_initialize(*args)
      @battle_info_boss_immunities = pending_immunities || {}
      begin
        if defined?($game_temp) && $game_temp &&
           $game_temp.respond_to?(:battle_info_pending_boss_immunities=)
          $game_temp.battle_info_pending_boss_immunities = {}
        end
      rescue
      end
    end
  end
end if defined?(Battle)

module BattleInfoSetBattleRuleImmunityCapture
  private

  def setBattleRule(rule, *args)
    BattleInfoBossImmunityCapture.capture(rule, args)
    super(rule, *args)
  end
end

[Object, (defined?(Game_Interpreter) ? Game_Interpreter : nil),
 (defined?(Interpreter) ? Interpreter : nil)].compact.uniq.each do |klass|
  begin
    klass.prepend(BattleInfoSetBattleRuleImmunityCapture) if !klass.ancestors.include?(BattleInfoSetBattleRuleImmunityCapture)
  rescue
  end
end

class Battle::Scene
  #-----------------------------------------------------------------------------
  # Handles the controls for the Battle Info UI.
  #-----------------------------------------------------------------------------
  def pbOpenBattlerInfo(battler, battlers)
    return if @enhancedUIToggle != :battler
    ret = nil
    idx = 0
    battlerTotal = battlers.flatten
    for i in 0...battlerTotal.length
      idx = i if battler == battlerTotal[i]
    end
    maxSize = battlerTotal.length - 1
    idxEffect = 0
    idxInnate = -1
    showImmunityPage = false
    effects = pbGetDisplayEffects(battler)
    effctSize = effects.length - 1
    innateSize = pbGetDisplayedInnateEntries(pbGetBattlerInfoInnatePokemon(battler)).length - 1
    immunity_entries = pbGetBattlerInfoImmunityEntries(battler)
    # Keep the Innate description panel hidden until the player intentionally
    # navigates to the Innates row with Up/Down.
    idxInnate = -1
    pbUpdateBattlerInfo(battler, effects, idxEffect, idxInnate, showImmunityPage)
    cw = @sprites["fightWindow"]
    @sprites["leftarrow"].x = -2
    @sprites["leftarrow"].y = 71
    @sprites["leftarrow"].visible = true
    @sprites["rightarrow"].x = Graphics.width - 38
    @sprites["rightarrow"].y = 71
    @sprites["rightarrow"].visible = true
    loop do
      pbUpdate(cw)
      pbUpdateInfoSprites
      doRefresh = false
      doFullRefresh = false
      if showImmunityPage
        if Input.trigger?(Input::BACK) || Input.trigger?(Input::DOWN) ||
           Input.trigger?(Input::UP) || Input.trigger?(Input::USE)
          showImmunityPage = false
          doRefresh = true
        end
      else
        break if Input.trigger?(Input::BACK)
        if Input.trigger?(Input::LEFT)
          idx -= 1
          idx = maxSize if idx < 0
          doFullRefresh = true
        elsif Input.trigger?(Input::RIGHT)
          idx += 1
          idx = 0 if idx > maxSize
          doFullRefresh = true
        elsif Input.repeat?(Input::UP)
          if idxInnate >= 0
            if idxInnate > 0
              idxInnate -= 1
            else
              # Pressing Up on the first Innate hides the description panel again
              # instead of wrapping or jumping back into another Innate description.
              idxInnate = -1
              idxEffect = effctSize if effects.length > 0
            end
            doRefresh = true
          elsif effects.length > 0
            if idxEffect > 0
              idxEffect -= 1
            elsif !immunity_entries.empty?
              showImmunityPage = true
            elsif innateSize >= 0
              idxInnate = innateSize
            elsif effects.length > 1
              idxEffect = effctSize
            end
            doRefresh = true if effects.length > 1 || innateSize >= 0 || !immunity_entries.empty?
          elsif !immunity_entries.empty?
            showImmunityPage = true
            doRefresh = true
          elsif innateSize >= 0
            idxInnate = innateSize
            doRefresh = true
          end
        elsif Input.repeat?(Input::DOWN)
          if idxInnate >= 0
            if idxInnate < innateSize
              idxInnate += 1
            elsif effects.length > 0
              idxInnate = -1
              idxEffect = 0
            else
              idxInnate = 0
            end
            doRefresh = true
          elsif effects.length > 0
            if idxEffect < effctSize
              idxEffect += 1
            elsif innateSize >= 0
              idxInnate = 0
            elsif effects.length > 1
              idxEffect = 0
            end
            doRefresh = true if effects.length > 1 || innateSize >= 0
          elsif innateSize >= 0
            idxInnate = 0
            doRefresh = true
          end
        elsif Input.trigger?(Input::JUMPDOWN)
          if cw.visible
            ret = 1
            break
          elsif @battle.pbCanUsePokeBall?(@sprites["enhancedUIPrompts"].battler)
            ret = 2
            break
          end
        elsif Input.trigger?(Input::JUMPUP) || Input.trigger?(Input::USE)
          ret = []
          if battler.opposes?
            ret.push(1)
            @battle.allOtherSideBattlers.reverse.each_with_index do |b, i| 
              next if b.index != battler.index
              ret.push(i)
            end
          else
            ret.push(0)
            @battle.allSameSideBattlers.each_with_index do |b, i| 
              next if b.index != battler.index
              ret.push(i)
            end
          end
          pbPlayDecisionSE
          break
        end
      end
      if doFullRefresh
        battler = battlerTotal[idx]
        effects = pbGetDisplayEffects(battler)
        effctSize = effects.length - 1
        innateSize = pbGetDisplayedInnateEntries(pbGetBattlerInfoInnatePokemon(battler)).length - 1
        immunity_entries = pbGetBattlerInfoImmunityEntries(battler)
        idxEffect = 0
        # Do not auto-open the Innate description panel when changing battlers,
        # even if there are no regular effects to display.
        idxInnate = -1
        showImmunityPage = false
        doRefresh = true
      end
      if doRefresh
        pbPlayCursorSE
        @sprites["leftarrow"].visible = !showImmunityPage
        @sprites["rightarrow"].visible = !showImmunityPage
        pbUpdateBattlerInfo(battler, effects, idxEffect, idxInnate, showImmunityPage)
        doRefresh = false
        doFullRefresh = false
      end
    end
    @sprites["leftarrow"].visible = false
    @sprites["rightarrow"].visible = false
    return ret
  end

  #-----------------------------------------------------------------------------
  # Idite: Boss immunity info display.
  #-----------------------------------------------------------------------------
  BATTLE_INFO_IMMUNITY_FALLBACKS = {
    :SLEEP          => [_INTL("Sleep"),          _INTL("Immune to Sleep from opposing effects, including Yawn and Synchronize.")],
    :POISON         => [_INTL("Poison"),         _INTL("Immune to the Poison status from opposing effects.")],
    :BURN           => [_INTL("Burn"),           _INTL("Immune to the Burn status from opposing effects.")],
    :PARALYSIS      => [_INTL("Paralysis"),      _INTL("Immune to the Paralysis status from opposing effects.")],
    :FROZEN         => [_INTL("Frozen"),         _INTL("Immune to the Frozen status from opposing effects.")],
    :FROSTBITE      => [_INTL("Frostbite"),      _INTL("Immune to the Frostbite status from opposing effects.")],
    :DROWSY         => [_INTL("Drowsy"),         _INTL("Immune to the Drowsy status from opposing effects.")],
    :CONFUSED       => [_INTL("Confusion"),      _INTL("Immune to being confused.")],
    :CONFUSION      => [_INTL("Confusion"),      _INTL("Immune to being confused.")],
    :ATTRACT        => [_INTL("Attract"),        _INTL("Immune to being infatuated.")],
    :ALLSTATUS      => [_INTL("All Status"),     _INTL("Immune to status conditions, confusion, and infatuation.")],
    :FLINCH         => [_INTL("Flinch"),         _INTL("Immune to being made to flinch.")],
    :CRITICALHIT    => [_INTL("Critical Hits"),  _INTL("Immune to taking critical hits.")],
    :STATDROPS      => [_INTL("Stat Drops"),     _INTL("Immune to opposing effects that lower stats.")],
    :PPLOSS         => [_INTL("PP Loss"),        _INTL("Its PP cannot be lowered by opposing effects.")],
    :TYPECHANGE     => [_INTL("Type Change"),    _INTL("Immune to effects that change its typing.")],
    :ITEMREMOVAL    => [_INTL("Item Removal"),   _INTL("Immune to effects that remove, replace, swap, or disable its held item.")],
    :ABILITYREMOVAL => [_INTL("Ability Removal"),_INTL("Immune to effects that remove, replace, swap, or disable its Ability.")],
    :INDIRECT       => [_INTL("Indirect Damage"),_INTL("Immune to indirect damage such as weather, recoil, hazards, status damage, and Leech Seed.")],
    :DISABLE        => [_INTL("Move Lock"),      _INTL("Immune to effects that disable or restrict its moves.")],
    :OHKO           => [_INTL("OHKO"),           _INTL("Immune to moves and effects that would instantly set its HP to zero.")],
    :SELFKO         => [_INTL("Self-KO"),        _INTL("Cannot make itself faint with self-KO moves or effects.")],
    :ESCAPE         => [_INTL("Escape"),         _INTL("Immune to effects that force it to flee or be forced out.")],
    :TRANSFORM      => [_INTL("Transform"),      _INTL("Immune to being copied or changed by Transform-style effects.")],
    :CONFUSERAY     => [_INTL("Confusion"),      _INTL("Immune to Confuse Ray and similar confusion effects.")],
    :INFERNALPARADE => [_INTL("Infernal Parade"),_INTL("Immune to Infernal Parade's special boss interaction/effect." )],
    :PAINSPLIT      => [_INTL("Pain Split"),     _INTL("Immune to Pain Split and similar HP-sharing effects.")],
    :POWERTRIP      => [_INTL("Power Trip"),     _INTL("Immune to Power Trip's special boss interaction/effect.")]
  } if !const_defined?(:BATTLE_INFO_IMMUNITY_FALLBACKS)

  BATTLE_INFO_HIDDEN_IMMUNITY_IDS = [:NONE, :RAIDBOSS] if !const_defined?(:BATTLE_INFO_HIDDEN_IMMUNITY_IDS)

  def pbNormalizeBattleInfoImmunityID(id)
    return nil if id.nil?
    id = id.id if id.respond_to?(:id)
    text = id.to_s
    text = text[1..-1] if text.start_with?(":")
    text = text.upcase
    return nil if text.empty?
    return text.to_sym
  rescue
    return nil
  end

  def pbHiddenBattleInfoImmunityID?(id)
    id = pbNormalizeBattleInfoImmunityID(id)
    return true if !id
    return BATTLE_INFO_HIDDEN_IMMUNITY_IDS.include?(id)
  end

  def pbExtractBattleInfoImmunityIDs(raw)
    return [] if raw.nil?
    if raw.is_a?(Hash)
      if raw.key?(:immunities) || raw.key?("immunities") || raw.key?(:boss_immunities) || raw.key?("boss_immunities")
        raw = raw[:immunities] || raw["immunities"] || raw[:boss_immunities] || raw["boss_immunities"]
      else
        raw = raw.keys.select { |key| raw[key] }
      end
    end
    ids = []
    Array(raw).flatten.each do |id|
      id = pbNormalizeBattleInfoImmunityID(id)
      next if pbHiddenBattleInfoImmunityID?(id)
      ids.push(id)
    end
    return ids.compact.uniq
  end

  def pbCollectBattleInfoImmunitiesFrom(obj)
    return [] if !obj
    ids = []
    [:immunities, :boss_immunities, :bossImmunities, :boss_immunity_ids,
     :boss_immunity, :bossImmunity, :raid_immunities, :battle_info_boss_immunities].each do |method_name|
      next if !obj.respond_to?(method_name)
      begin
        ids.concat(pbExtractBattleInfoImmunityIDs(obj.send(method_name)))
      rescue
      end
    end
    [:@immunities, :@boss_immunities, :@bossImmunities, :@boss_immunity_ids,
     :@boss_immunity, :@bossImmunity, :@raid_immunities, :@battle_info_boss_immunities].each do |ivar|
      next if !obj.instance_variable_defined?(ivar)
      begin
        ids.concat(pbExtractBattleInfoImmunityIDs(obj.instance_variable_get(ivar)))
      rescue
      end
    end
    return ids.compact.uniq
  end

  def pbBattleInfoPokemonSourceIndex(battler)
    return nil if !battler
    begin
      return battler.pokemonIndex if battler.respond_to?(:pokemonIndex)
    rescue
    end
    begin
      return battler.instance_variable_get(:@pokemonIndex) if battler.instance_variable_defined?(:@pokemonIndex)
    rescue
    end
    begin
      return battler.opposes? ? (battler.index / 2) : (battler.index / 2)
    rescue
      return nil
    end
  end

  def pbBattleInfoPokemonSources(battler)
    sources = []
    return sources if !battler
    [:pokemon, :displayPokemon].each do |method_name|
      next if !battler.respond_to?(method_name)
      begin
        sources.push(battler.send(method_name))
      rescue
      end
    end
    [:@pokemon, :@displayPokemon, :@display_pokemon].each do |ivar|
      next if !battler.instance_variable_defined?(ivar)
      begin
        sources.push(battler.instance_variable_get(ivar))
      rescue
      end
    end
    pkmn_index = pbBattleInfoPokemonSourceIndex(battler)
    if @battle
      begin
        if @battle.respond_to?(:pbParty)
          party = @battle.pbParty(battler.index)
          sources.push(party[pkmn_index]) if party && pkmn_index && party[pkmn_index]
        end
      rescue
      end
      begin
        party_ivar = battler.opposes? ? :@party2 : :@party1
        party = @battle.instance_variable_get(party_ivar) if @battle.instance_variable_defined?(party_ivar)
        sources.push(party[pkmn_index]) if party && pkmn_index && party[pkmn_index]
      rescue
      end
      begin
        # Last-resort mapping for wild/double wild foes: enemy battlers use 1, 3, 5.
        if battler.opposes? && @battle.instance_variable_defined?(:@party2)
          party = @battle.instance_variable_get(:@party2)
          side_slot = battler.index / 2
          sources.push(party[side_slot]) if party && party[side_slot]
        end
      rescue
      end
    end
    return sources.compact.uniq
  end

  def pbBattleInfoImmunityKnownIDs
    return BATTLE_INFO_IMMUNITY_FALLBACKS.keys.compact.uniq
  end

  def pbCollectBattleInfoImmunitiesFromRuleCache(battler)
    return [] if !battler || !@battle
    begin
      return [] if !battler.opposes?
    rescue
      return []
    end
    cache = nil
    begin
      if @battle.respond_to?(:battle_info_boss_immunities)
        cache = @battle.battle_info_boss_immunities
      elsif @battle.instance_variable_defined?(:@battle_info_boss_immunities)
        cache = @battle.instance_variable_get(:@battle_info_boss_immunities)
      end
    rescue
      cache = nil
    end
    return [] if !cache || !cache.is_a?(Hash) || cache.empty?
    slot = 0
    begin
      slot = battler.index / 2
    rescue
      slot = 0
    end
    raw = cache[slot] || cache[slot.to_s]
    return pbExtractBattleInfoImmunityIDs(raw).compact.uniq
  end

  def pbGetBattleInfoImmunityData(immunity_id)
    id = pbNormalizeBattleInfoImmunityID(immunity_id)
    fallback = BATTLE_INFO_IMMUNITY_FALLBACKS[id]
    if fallback
      return { :name => fallback[0], :description => fallback[1] }
    end
    return {
      :name        => id.to_s.split("_").map { |w| w.capitalize }.join(" "),
      :description => _INTL("No description is available.")
    }
  end

  def pbGetBattlerInfoImmunityIDs(battler)
    return [] if !battler
    begin
      return [] if !battler.opposes?
    rescue
      return []
    end

    ids = []
    sources = []
    begin
      sources.push(battler.pokemon) if battler.respond_to?(:pokemon)
    rescue
    end
    begin
      sources.push(battler.instance_variable_get(:@pokemon)) if battler.instance_variable_defined?(:@pokemon)
    rescue
    end
    begin
      sources.push(battler.displayPokemon) if battler.respond_to?(:displayPokemon)
    rescue
    end
    sources.compact.uniq.each do |pkmn|
      ids.concat(pbCollectBattleInfoImmunitiesFrom(pkmn))
    end

    ids.concat(pbCollectBattleInfoImmunitiesFromRuleCache(battler)) if ids.empty?
    return ids.compact.uniq.reject { |id| pbHiddenBattleInfoImmunityID?(id) }
  end

  def pbGetBattlerInfoImmunityEntries(battler)
    entries = []
    pbGetBattlerInfoImmunityIDs(battler).each do |id|
      data = pbGetBattleInfoImmunityData(id)
      entries.push({
        :id          => id,
        :symbol      => ":#{id}",
        :name        => data[:name],
        :description => data[:description]
      })
    end
    return entries
  end

  def pbAddBattleInfoImmunityIcon(imagePos, entries)
    return if entries.empty?
    return if !pbResolveBitmap(@path + "immunities")
    imagePos.push([@path + "immunities", 8, 8])
  end

  def pbDrawBattleInfoWrappedText(text, x, y, width, base, shadow, line_height = 20, max_lines = nil)
    lines = pbWrapBattleInfoText(text.to_s, width, @enhancedUIOverlay)
    lines = lines[0, max_lines] if max_lines
    lines.each do |line|
      drawTextEx(@enhancedUIOverlay, x, y, width, 0, line, base, shadow)
      y += line_height
    end
    return y
  end

  def pbDrawBattlerInfoImmunityPage(battler, entries)
    overlay = @enhancedUIOverlay
    overlay.fill_rect(0, 0, Graphics.width, Graphics.height, Color.new(224, 232, 232))
    overlay.fill_rect(0, 0, Graphics.width, 2, Color.new(72, 88, 88))
    overlay.fill_rect(0, Graphics.height - 2, Graphics.width, 2, Color.new(72, 88, 88))
    overlay.fill_rect(0, 0, 2, Graphics.height, Color.new(72, 88, 88))
    overlay.fill_rect(Graphics.width - 2, 0, 2, Graphics.height, Color.new(72, 88, 88))
    # immunities.png graphic on the new page. 14, 12
    pbDrawImagePositions(overlay, [[@path + "immunities", 4, 2]]) if pbResolveBitmap(@path + "immunities")
    poke = battler.pokemon rescue nil
    poke = battler.displayPokemon if !poke && battler.respond_to?(:displayPokemon)
    title_name = poke && poke.respond_to?(:name) ? poke.name : battler.pbThis
    title = _INTL("{1}'s Immunities", title_name)
    # Draw Title
    drawTextEx(overlay, 48, 18, Graphics.width - 68, 0, title, BASE_DARK, SHADOW_DARK)
    overlay.fill_rect(12, 42, Graphics.width - 24, 2, Color.new(72, 88, 88))
    if entries.empty?
      drawFormattedTextEx(overlay, 18, 62, Graphics.width - 36,
                          _INTL("This Pokémon has no listed boss immunities."),
                          BASE_DARK, SHADOW_DARK, 18)
      return
    end
    y = 54
    entry_w = Graphics.width - 36
    entries.each do |entry|
      break if y > Graphics.height - 58
      name = entry[:name] || entry[:id].to_s
      desc = entry[:description] || _INTL("No description is available.")
      overlay.fill_rect(14, y - 2, Graphics.width - 28, 24, Color.new(200, 212, 212))
      drawTextEx(overlay, 22, y + 2, entry_w, 0, name, BASE_DARK, SHADOW_DARK)
      y += 26
      y = pbDrawBattleInfoWrappedText(desc, 28, y, entry_w - 10, BASE_DARK, SHADOW_DARK, 18, 3)
      y += 6
    end
    if entries.length > 0
      footer = _INTL("Press Back, Up, Down, or Confirm to return.")
      drawTextEx(overlay, 18, Graphics.height - 28, Graphics.width - 36, 1, footer, BASE_DARK, SHADOW_DARK)
    end
  end

  #-----------------------------------------------------------------------------
  # Idite: Grabs Innates
  #-----------------------------------------------------------------------------
  def pbGetBattlerInfoInnatePokemon(battler)
    return nil if !battler
    poke = (battler.opposes?) ? battler.displayPokemon : battler.pokemon
    return battler.pokemon || poke
  end

  def pbGetInnateDescription(innate_id, innate_data = nil)
    return "" if !innate_id
    data = innate_data
    ability_data = nil
    if defined?(GameData::Ability)
      ability_data = GameData::Ability.try_get(innate_id) rescue nil
    end
    data = ability_data if !data && ability_data
    if data && data.respond_to?(:description)
      return data.description
    elsif data && data.respond_to?(:desc)
      return data.desc
    elsif ability_data && ability_data.respond_to?(:description)
      return ability_data.description
    end
    return _INTL("No description is available.")
  end

  def pbGetDisplayedInnateEntries(poke)
    return [] if !poke

    active_innates = []
    if poke.respond_to?(:active_innates)
      active_innates = poke.active_innates || []
    end
    if active_innates.empty? && poke.respond_to?(:assign_innate_abilities)
      poke.assign_innate_abilities
      active_innates = poke.active_innates || []
    end

    entries = []
    3.times do |i|
      innate_id = active_innates[i]
      innate_data = GameData::Innate.try_get(innate_id) rescue nil
      next if !innate_id || !innate_data
      name = innate_data.respond_to?(:name) ? innate_data.name : innate_id.to_s
      desc = pbGetInnateDescription(innate_id, innate_data)
      entries.push({ :id => innate_id, :name => name, :description => desc, :slot => i })
    end
    return entries
  end

  def pbGetDisplayedInnates(poke)
    names = ["---", "---", "---"]
    pbGetDisplayedInnateEntries(poke).each do |entry|
      names[entry[:slot]] = entry[:name]
    end
    return names
  end

  #-----------------------------------------------------------------------------
  # Wrap helper for long innate names.
  #-----------------------------------------------------------------------------
  def pbWrapBattleInfoText(text, max_width, bitmap)
    return [""] if !text
    words = text.split(/\s+/)
    return [text] if words.empty?
    lines = []
    current_line = ""
    words.each do |word|
      test_line = current_line.empty? ? word : "#{current_line} #{word}"
      if bitmap.text_size(test_line).width > max_width && !current_line.empty?
        lines << current_line
        current_line = word
      else
        current_line = test_line
      end
    end
    lines << current_line if !current_line.empty?
    return lines
  end

  #-----------------------------------------------------------------------------
  # Draws an innate name into one of the new boxes.
  #-----------------------------------------------------------------------------
  def pbDrawBattleInfoInnateName(name, x, y, width, base, shadow, selected = false)
    overlay = @enhancedUIOverlay
    text = name || "---"
    if selected
      overlay.fill_rect(x - 4, y - 4, width + 8, 26, Color.new(56, 56, 56))
      base = BASE_LIGHT
      shadow = SHADOW_LIGHT
    end
    if overlay.text_size(text).width <= width
      drawTextEx(overlay, x, y, width, 2, text, base, shadow)
      return
    end

    pbSetSmallFont(overlay)
    lines = pbWrapBattleInfoText(text, width, overlay)
    y_offset = (lines.length > 1) ? -8 : 0
    lines[0, 2].each_with_index do |line, i|
      drawTextEx(overlay, x, y + y_offset + (i * 18), width, 2, line, base, shadow)
    end
    pbSetSystemFont(overlay)
  end

  #-----------------------------------------------------------------------------
  # Draws the selected innate's ability description above the innate name row.
  #-----------------------------------------------------------------------------
  def pbDrawBattleInfoInnateDescription(entry)
    return if !entry
    overlay = @enhancedUIOverlay
    box_x = 0
    box_y = Graphics.height - 98
    box_w = Graphics.width
    box_h = 58
    overlay.fill_rect(box_x, box_y, box_w, box_h, Color.new(224, 232, 232))
    overlay.fill_rect(box_x, box_y, box_w, 2, Color.new(72, 88, 88))
    overlay.fill_rect(box_x, box_y + box_h - 2, box_w, 2, Color.new(72, 88, 88))
    overlay.fill_rect(box_x, box_y, 2, box_h, Color.new(72, 88, 88))
    overlay.fill_rect(box_x + box_w - 2, box_y, 2, box_h, Color.new(72, 88, 88))
    name = entry[:name] || "---"
    desc = entry[:description] || _INTL("No description is available.")
    text = _INTL("{1}: {2}", name, desc)
    drawFormattedTextEx(overlay, box_x + 10, box_y + 8, box_w - 20, text, BASE_DARK, SHADOW_DARK, 18)
  end

  #-----------------------------------------------------------------------------
  # Draws the Battle Info UI.
  #-----------------------------------------------------------------------------
  def pbUpdateBattlerInfo(battler, effects, idxEffect = 0, idxInnate = -1, showImmunityPage = false)


    @enhancedUIOverlay.clear
    pbUpdateBattlerIcons
    return if @enhancedUIToggle != :battler
    immunity_entries = pbGetBattlerInfoImmunityEntries(battler)
    if showImmunityPage
      @battle.allBattlers.each do |b|
        @sprites["info_icon#{b.index}"].visible = false if @sprites["info_icon#{b.index}"]
      end
      pbDrawBattlerInfoImmunityPage(battler, immunity_entries)
      return
    end
    xpos = 28
    ypos = 24
    iconX = xpos + 28
    iconY = ypos + 62
    panelX = xpos + 240
    #---------------------------------------------------------------------------
    # General UI elements.
    # Idite - Innates
    poke = (battler.opposes?) ? battler.displayPokemon : battler.pokemon
    poke_for_innates = pbGetBattlerInfoInnatePokemon(battler)
    innates = pbGetDisplayedInnates(poke_for_innates)
    innate_entries = pbGetDisplayedInnateEntries(poke_for_innates)

    level = (battler.isRaidBoss?) ? "???" : battler.level.to_s
    movename = (battler.lastMoveUsed) ? GameData::Move.get(battler.lastMoveUsed).name : "---"
    movename = movename[0..12] + "..." if movename.length > 16
    imagePos = [
      [@path + "info_bg", 0, 0],
      [@path + "info_bg_data", 0, 0],
      [@path + "info_level", xpos + 16, ypos + 106]
    ]
    pbAddBattleInfoImmunityIcon(imagePos, immunity_entries)
    imagePos.push([@path + "info_gender", xpos + 148, ypos + 22, poke.gender * 22, 0, 22, 22]) if !battler.isRaidBoss?
    textPos  = [
      [_INTL("{1}", poke.name), iconX + 82, iconY - 20, :center, BASE_DARK, SHADOW_DARK],
      [_INTL("{1}", level), xpos + 38, ypos + 104, :left, BASE_LIGHT, SHADOW_LIGHT],
      [_INTL("Used: {1}", movename), xpos + 349, ypos + 104, :center, BASE_LIGHT, SHADOW_LIGHT],
      [_INTL("Turn {1}", @battle.turnCount + 1), Graphics.width - xpos - 32, ypos + 8, :center, BASE_DARK, SHADOW_DARK]
    ]
    #---------------------------------------------------------------------------
    # Battler icon.
    @battle.allBattlers.each do |b|
      @sprites["info_icon#{b.index}"].x = iconX
      @sprites["info_icon#{b.index}"].y = iconY
      @sprites["info_icon#{b.index}"].visible = (b.index == battler.index)
    end            
    #---------------------------------------------------------------------------
    # Owner
    if !battler.wild?
      imagePos.push([@path + "info_owner", xpos - 34, ypos + 6, 0, 20, 128, 20])
      textPos.push([@battle.pbGetOwnerFromBattlerIndex(battler.index).name, xpos + 32, ypos + 8, :center, BASE_DARK, SHADOW_DARK])
    end
    # Battler HP.
    if battler.hp > 0
      w = battler.hp * 96 / battler.totalhp.to_f
      w = 1 if w < 1
      w = ((w / 2).round) * 2
      hpzone = 0
      hpzone = 1 if battler.hp <= (battler.totalhp / 2).floor
      hpzone = 2 if battler.hp <= (battler.totalhp / 4).floor
      imagePos.push([@path + "info_hp", 86, 86, 0, hpzone * 6, w, 6])
    end
    # Battler status.
    if battler.status != :NONE
      iconPos = GameData::Status.get(battler.status).icon_position
      imagePos.push(["Graphics/UI/statuses", xpos + 86, ypos + 104, 0, iconPos * 16, 44, 16])
    end
    # Shininess
    imagePos.push(["Graphics/UI/shiny", xpos + 142, ypos + 102]) if poke.shiny?
    #---------------------------------------------------------------------------
    # Battler info for player-owned Pokemon.
    if battler.pbOwnedByPlayer?
      imagePos.push(
        [@path + "info_owner", xpos + 36, iconY + 10, 0, 0, 128, 20],
        [@path + "info_cursor", panelX, 62, 0, 0, 218, 26],
        [@path + "info_cursor", panelX, 86, 0, 0, 218, 26]
      )
      textPos.push(
        [_INTL("Abil."), xpos + 272, ypos + 44, :center, BASE_LIGHT, SHADOW_LIGHT],
        [_INTL("Item"), xpos + 272, ypos + 68, :center, BASE_LIGHT, SHADOW_LIGHT],
        [_INTL("{1}", battler.abilityName), xpos + 376, ypos + 44, :center, BASE_DARK, SHADOW_DARK],
        [_INTL("{1}", battler.itemName), xpos + 376, ypos + 68, :center, BASE_DARK, SHADOW_DARK],
        [sprintf("%d/%d", battler.hp, battler.totalhp), iconX + 74, iconY + 12, :center, BASE_LIGHT, SHADOW_LIGHT]
      )
    end
    #---------------------------------------------------------------------------
    # Idite - Innates
    textPos.push(
      [_INTL("1"), xpos - 12, ypos + 336, :center, BASE_LIGHT, SHADOW_LIGHT],
      [_INTL("2"), xpos + 160, ypos + 336, :center, BASE_LIGHT, SHADOW_LIGHT],
      [_INTL("3"), xpos + 332, ypos + 336, :center, BASE_LIGHT, SHADOW_LIGHT]
    )
    #---------------------------------------------------------------------------
    pbAddWildIconDisplay(xpos, ypos, battler, imagePos)
    pbAddStatsDisplay(xpos, ypos, battler, imagePos, textPos)
    pbDrawImagePositions(@enhancedUIOverlay, imagePos)
    pbDrawTextPositions(@enhancedUIOverlay, textPos)

    # Idite - Innates
    selected_innate_slot = -1
    if idxInnate >= 0 && innate_entries[idxInnate]
      selected_innate_slot = innate_entries[idxInnate][:slot]
    end
    pbDrawBattleInfoInnateName(innates[0], xpos + 4, ypos + 336, 138, BASE_DARK, SHADOW_DARK, selected_innate_slot == 0)
    pbDrawBattleInfoInnateName(innates[1], xpos + 176, ypos + 336, 138, BASE_DARK, SHADOW_DARK, selected_innate_slot == 1)
    pbDrawBattleInfoInnateName(innates[2], xpos + 350, ypos + 336, 138, BASE_DARK, SHADOW_DARK, selected_innate_slot == 2)

    pbAddTypesDisplay(xpos, ypos, battler, poke)
    pbAddEffectsDisplay(xpos, ypos, panelX, effects, idxEffect)
    pbDrawBattleInfoInnateDescription(innate_entries[idxInnate]) if idxInnate >= 0
  end
  
  #-----------------------------------------------------------------------------
  # Draws additional icons on wild Pokemon to display cosmetic attributes.
  #-----------------------------------------------------------------------------
  def pbAddWildIconDisplay(xpos, ypos, battler, imagePos)
    return if !battler.wild?
    images = []
    pkmn = battler.pokemon
    #---------------------------------------------------------------------------
    # Checks if the wild Pokemon has at least one Shiny Leaf.
    if defined?(pkmn.shiny_leaf) && pkmn.shiny_leaf > 0
      images.push([Settings::POKEMON_UI_GRAPHICS_PATH + "leaf", 12, 10])
    end
    #---------------------------------------------------------------------------
    # Checks if the wild Pokemon's size is small or large.
    if defined?(pkmn.scale)
      case pkmn.scale
      when 0..59
        images.push([Settings::MEMENTOS_GRAPHICS_PATH + "size_icon", 6, 2, 0, 0, 28, 28])
      when 196..255
        images.push([Settings::MEMENTOS_GRAPHICS_PATH + "size_icon", 6, 4, 28, 0, 28, 28])
      end
    end
    #---------------------------------------------------------------------------
    # Checks if the wild Pokemon has a mark.
    if defined?(pkmn.memento) && pkmn.hasMementoType?(:mark)
      images.push([Settings::MEMENTOS_GRAPHICS_PATH + "memento_icon", 6, 4, 0, 0, 28, 28])
    end
    #---------------------------------------------------------------------------
    # Draws all cosmetic icons.
    if !images.empty?
      offset = images.length - 1
      baseX = xpos + 328 - offset * 26
      baseY = ypos + 42
      images.each_with_index do |img, i|
        imagePos.push([@path + "info_extra", baseX + (50 * i), baseY])
        img[1] += baseX + (50 * i)
        img[2] += baseY
        imagePos.push(img)
      end
    end
  end
  
  #-----------------------------------------------------------------------------
  # Draws the battler's stats and stat stages.
  #-----------------------------------------------------------------------------
  def pbAddStatsDisplay(xpos, ypos, battler, imagePos, textPos)
    [[:ATTACK,          _INTL("Attack")],
     [:DEFENSE,         _INTL("Defense")], 
     [:SPECIAL_ATTACK,  _INTL("Sp. Atk")], 
     [:SPECIAL_DEFENSE, _INTL("Sp. Def")], 
     [:SPEED,           _INTL("Speed")], 
     [:ACCURACY,        _INTL("Accuracy")], 
     [:EVASION,         _INTL("Evasion")],
     _INTL("Crit. Hit")
    ].each_with_index do |stat, i|
      if stat.is_a?(Array)
        color = SHADOW_LIGHT
        if battler.pbOwnedByPlayer?
          battler.pokemon.nature_for_stats.stat_changes.each do |s|
            if stat[0] == s[0]
              color = Color.new(136, 96, 72)  if s[1] > 0 # Red Nature text.
              color = Color.new(64, 120, 152) if s[1] < 0 # Blue Nature text.
            end
          end
        end
        textPos.push([stat[1], xpos + 16, ypos + 138 + (i * 24), :left, BASE_LIGHT, color])
        stage = battler.stages[stat[0]]
      else
        textPos.push([stat, xpos + 16, ypos + 138 + (i * 24), :left, BASE_LIGHT, SHADOW_LIGHT])
        stage = [battler.effects[PBEffects::FocusEnergy], 3].min
      end
      if stage != 0
        arrow = (stage > 0) ? 0 : 18
        stage.abs.times do |t| 
          imagePos.push([@path + "info_stats", xpos + 110 + (t * 18), ypos + 136 + (i * 24), arrow, 0, 18, 18])
        end
      end
    end
  end
  
  #-----------------------------------------------------------------------------
  # Draws the battler's typing.
  #-----------------------------------------------------------------------------
  def pbAddTypesDisplay(xpos, ypos, battler, poke)
    #---------------------------------------------------------------------------
    # Gets display types (considers Illusion)
    illusion = battler.effects[PBEffects::Illusion] && !battler.pbOwnedByPlayer?
    if battler.tera?
      displayTypes = (illusion) ? poke.types.clone : battler.pbPreTeraTypes
    elsif illusion
      displayTypes = poke.types.clone
      displayTypes.push(battler.effects[PBEffects::ExtraType]) if battler.effects[PBEffects::ExtraType]
    else
      displayTypes = battler.pbTypes(true)
    end
    #---------------------------------------------------------------------------
    # Displays the "???" type on newly encountered species, or battlers with no typing.
    if Settings::SHOW_TYPE_EFFECTIVENESS_FOR_NEW_SPECIES
      unknown_species = false
    else
      unknown_species = !(
        !@battle.internalBattle ||
        battler.pbOwnedByPlayer? ||
        $player.pokedex.owned?(poke.species) ||
        $player.pokedex.battled_count(poke.species) > 0
      )
    end
    displayTypes = [:QMARKS] if unknown_species || displayTypes.empty?
    #---------------------------------------------------------------------------
    # Draws each display type. Maximum of 3 types.
    typeY = (displayTypes.length >= 3) ? ypos + 6 : ypos + 34
    typebitmap = AnimatedBitmap.new(_INTL("Graphics/UI/types"))
    displayTypes.each_with_index do |type, i|
      break if i > 2
      type_number = GameData::Type.get(type).icon_position
      type_rect = Rect.new(0, type_number * 28, 64, 28)
      @enhancedUIOverlay.blt(xpos + 170, typeY + (i * 30), typebitmap.bitmap, type_rect)
    end
    #---------------------------------------------------------------------------
    # Draws Tera type.
    if battler.tera?
      showTera = true
    else
      showTera = defined?(battler.tera_type) && battler.pokemon.terastal_able?
      showTera = ((@battle.internalBattle) ? !battler.opposes? : true) if showTera
    end
    if showTera
      pkmn = (illusion) ? poke : battler
      pbDrawImagePositions(@enhancedUIOverlay, [[@path + "info_extra", xpos + 182, ypos + 95]])
      pbDisplayTeraType(pkmn, @enhancedUIOverlay, xpos + 186, ypos + 97, true)
    end
  end
  
  #-----------------------------------------------------------------------------
  # Draws the effects in play that are affecting the battler.
  #-----------------------------------------------------------------------------
  def pbAddEffectsDisplay(xpos, ypos, panelX, effects, idxEffect)
    return if effects.empty?
    idxLast = effects.length - 1
    offset = idxLast - 1
    if idxEffect < 4
      idxDisplay = idxEffect
    elsif [idxLast, offset].include?(idxEffect)
      idxDisplay = idxEffect
      idxDisplay -= 1 if idxDisplay == offset && offset < 5
    else
      idxDisplay = 3   
    end
    idxStart = (idxEffect > 3) ? idxEffect - 3 : 0
    if idxLast - idxEffect > 0
      idxEnd = idxStart + 4
    else
      idxStart = (idxLast - 4 > 0) ? idxLast - 4 : 0
      idxEnd = idxLast
    end
    textPos = []
    imagePos = [
      [@path + "info_effects", xpos + 240, ypos + 256],
      [@path + "info_slider_base", panelX + 222, ypos + 132]
    ]
    #---------------------------------------------------------------------------
    # Draws the slider.
    #---------------------------------------------------------------------------
    if effects.length > 5
      imagePos.push([@path + "info_slider", panelX + 222, ypos + 132, 0, 0, 18, 19]) if idxEffect > 3
      imagePos.push([@path + "info_slider", panelX + 222, ypos + 233, 0, 19, 18, 19]) if idxEffect < idxLast - 1
      sliderheight = 82
      boxheight = (sliderheight * 4 / idxLast).floor
      boxheight += [(sliderheight - boxheight) / 2, sliderheight / 4].min
      boxheight = [boxheight.floor, 18].max
      y = ypos + 152
      y += ((sliderheight - boxheight) * idxStart / (idxLast - 4)).floor
      imagePos.push([@path + "info_slider", panelX + 222, y, 18, 0, 18, 4])
      i = 0
      while i * 7 < boxheight - 2 - 7
        height = [boxheight - 2 - 7 - (i * 7), 7].min
        offset = y + 2 + (i * 7)
        imagePos.push([@path + "info_slider", panelX + 222, offset, 18, 2, 18, height])
        i += 1
      end
      imagePos.push([@path + "info_slider", panelX + 222, y + boxheight - 6 - 7, 18, 9, 18, 12])
    end
    #---------------------------------------------------------------------------
    # Draws each effect and the cursor.
    #---------------------------------------------------------------------------
    effects[idxStart..idxEnd].each_with_index do |effect, i|
      real_idx = effects.find_index(effect)
      if i == idxDisplay || idxEffect == real_idx
        imagePos.push([@path + "info_cursor", panelX, ypos + 132 + (i * 24), 0, 52, 218, 26])
        textPos.push([effect[0], xpos + 322, ypos + 138 + (i * 24), :center, BASE_LIGHT, SHADOW_LIGHT, :outline])
      else
        imagePos.push([@path + "info_cursor", panelX, ypos + 132 + (i * 24), 0, 26, 218, 26])
        textPos.push([effect[0], xpos + 322, ypos + 138 + (i * 24), :center, BASE_DARK, SHADOW_DARK])
      end
      textPos.push([effect[1], xpos + 426, ypos + 138 + (i * 24), :center, BASE_LIGHT, SHADOW_LIGHT])
    end
    pbDrawImagePositions(@enhancedUIOverlay, imagePos)
    pbDrawTextPositions(@enhancedUIOverlay, textPos)
    desc = effects[idxEffect][2]
    drawFormattedTextEx(@enhancedUIOverlay, xpos + 246, ypos + 266, 210, desc, BASE_DARK, SHADOW_DARK, 18)
  end
  
  #-----------------------------------------------------------------------------
  # Utility for getting an array of all effects that may be displayed.
  #-----------------------------------------------------------------------------
  def pbGetDisplayEffects(battler)
    display_effects = []
    #---------------------------------------------------------------------------
    # Damage gates for scripted battles.
    if battler.damageThreshold
      desc = _INTL("The Pokémon's HP won't fall below {1}% when attacked.", battler.damageThreshold.abs)
      display_effects.push([_INTL("Damage Gate"), "--", desc])
    end
    #---------------------------------------------------------------------------
    # Raid battle shields.
    if battler.hasRaidShield?
      desc = _INTL("The Pokémon is immune to status moves and takes less damage.")
      tick = sprintf("%d/%d", battler.shieldHP, @battle.raidRules[:shield_hp])
      display_effects.push([_INTL("Raid Shield"), tick, desc])
    end
    #---------------------------------------------------------------------------
    # Special states.
    if battler.mega?
      desc = _INTL("The Pokémon is in its Mega Evolved form.")
      display_effects.push([_INTL("Mega Evolution"), "--", desc])
    elsif battler.primal?
      desc = _INTL("The Pokémon is in its Primal form.")
      display_effects.push([_INTL("Primal Reversion"), "--", desc])
    elsif battler.ultra?
      desc = _INTL("The Pokémon is in its Ultra form.")
      display_effects.push([_INTL("Ultra Burst"), "--", desc])
    elsif battler.dynamax?
      if battler.effects[PBEffects::Dynamax] > 0 && !battler.isRaidBoss?
        tick = sprintf("%d/%d", battler.effects[PBEffects::Dynamax], Settings::DYNAMAX_TURNS)
      else
        tick = "--"
      end
      desc = _INTL("The Pokémon is in the Dynamax state.")
      display_effects.push([_INTL("Dynamax"), tick, desc])
    elsif battler.tera?
      data = GameData::Type.get(battler.tera_type).name
      desc = _INTL("The Pokémon is Terastallized into the {1} type.", data)
      display_effects.push([_INTL("Terastallization"), "--", desc])
    end
    #---------------------------------------------------------------------------
    # Weather
    weather = (battler.pbOwnedByPlayer?) ? battler.effectiveWeather : @battle.field.weather
    weather_data = GameData::BattleWeather.try_get(weather)
    if !weather_data.nil? && weather_data.id != :None
      id = weather_data.id
      name = weather_data.name
      if defined?(Settings::HAIL_WEATHER_TYPE) && id == :Hail
        case Settings::HAIL_WEATHER_TYPE
        when 1 then id = :Snow;      name = _INTL("Snow")
        when 2 then id = :Hailstorm; name = _INTL("Hailstorm")
        end
      end
      case id
      when :Sun         then desc = _INTL("Fire type moves deal 50% more damage. Halves Water move damage.")
      when :HarshSun    then desc = _INTL("Fire type moves deal 50% more damage. Negates Water type moves.")
      when :Rain        then desc = _INTL("Water type moves deal 50% more damage. Halves Fire move damage.")
      when :HeavyRain   then desc = _INTL("Water type moves deal 50% more damage. Negates Fire type moves.")
      when :StrongWinds then desc = _INTL("All Flying-type weaknesses are suppressed.")
      when :Hailstorm   then desc = _INTL("The combined effects of both Hail and Snow.")
      when :Sandstorm
        if battler.pbOwnedByPlayer? && battler.pbHasType?(:ROCK)
          desc = _INTL("Boosts the Sp. Defense stat of the Pokémon by 50%.")
        elsif battler.pbOwnedByPlayer? && battler.takesSandstormDamage?
          desc = _INTL("The Pokémon loses {1} HP each turn.", (battler.real_totalhp / 16).floor)
        else
          desc = _INTL("Pokémon may lose HP each turn. Boosts Sp. Defense of Rock types.")
        end
      when :Hail
        if battler.pbOwnedByPlayer? && battler.takesHailDamage?
          desc = _INTL("The Pokémon loses {1} HP each turn. Blizzard always hits.", (battler.real_totalhp / 16).floor)
        else
          desc = _INTL("Pokémon may lose HP each turn. Blizzard always hits.")
        end
      when :Snow
        if battler.pbOwnedByPlayer? && battler.pbHasType?(:ICE)
          desc = _INTL("Boosts the Defense of the Pokémon by 50%. Blizzard always hits.")
        else
          desc = _INTL("The move Blizzard always hits. Boosts Defense of Ice types.")
        end
      when :ShadowSky
        if battler.shadowPokemon?
          desc = _INTL("The power of the Pokémon's Shadow type moves are boosted by 50%.")
        elsif battler.pbOwnedByPlayer?
          desc = _INTL("The Pokémon loses {1} HP each turn.", (battler.real_totalhp / 16).floor)
        else
          desc = _INTL("Non-Shadow Pokémon may lose HP each turn.")
        end
      else
        desc = _INTL("Unknown weather.")
      end
      tick = (weather == @battle.field.weather) ? @battle.field.weatherDuration : 0
      tick = (tick > 0) ? sprintf("%d/%d", tick, 5) : "--"
      display_effects.push([name, tick, desc])
    end
    #---------------------------------------------------------------------------
    # Terrain
    if @battle.field.terrain != :None && (!battler.pbOwnedByPlayer? || battler.affectedByTerrain?)
      name = _INTL("{1} Terrain", GameData::BattleTerrain.get(@battle.field.terrain).name)
      tick = @battle.field.terrainDuration
      tick = (tick > 0) ? sprintf("%d/%d", tick, 5) : "--"
      case @battle.field.terrain
      when :Electric
        if battler.pbOwnedByPlayer?
          desc = _INTL("The Pokémon can't fall asleep. Electric moves boosted by 30%.")
        else
          desc = _INTL("Grounded Pokémon can't fall asleep. Boosts Electric moves.")
        end
      when :Grassy
        if battler.pbOwnedByPlayer?
          desc = _INTL("The Pokémon heals {1} HP each turn. Grass moves boosted by 30%.", (battler.real_totalhp / 16).floor)
        else
          desc = _INTL("Grounded Pokémon may recover HP each turn. Boosts Grass moves.")
        end
      when :Psychic
        if battler.pbOwnedByPlayer?
          desc = _INTL("The Pokémon is immune to priority. Psychic moves boosted by 30%.")
        else
          desc = _INTL("Grounded Pokémon immune to priority. Boosts Psychic moves.")
        end
      when :Misty
        if battler.pbOwnedByPlayer?
          desc = _INTL("The Pokémon is immune to statuses. Dragon moves weakened.")
        else
          desc = _INTL("Grounded Pokémon immune to statuses. Weakens Dragon moves.")
        end
      else
        desc = _INTL("Unknown terrain.")
      end
      display_effects.push([name, tick, desc])
    end
    #---------------------------------------------------------------------------
    # All eligible PBEffects.
    $DELUXE_PBEFFECTS.each do |key, key_hash|
      key_hash.each do |type, effects|
        effects.each do |effect|
          next if !PBEffects.const_defined?(effect)
          tick = "--"
          eff = PBEffects.const_get(effect)
          case key
          when :field    then value = @battle.field.effects[eff]
          when :team     then value = battler.pbOwnSide.effects[eff]
          when :position then value = @battle.positions[battler.index].effects[eff]
          when :battler  then value = battler.effects[eff]
          end
          case type
          when :boolean then next if !value
          when :counter then next if value == 0
          when :index   then next if value < 0
          end
          case effect
          ######################################################################
          #
          # FIELD EFFECTS
          #
          ######################################################################
          when :IonDeluge
            name = GameData::Move.get(:IONDELUGE).name
            desc = _INTL("Normal type moves of all Pokémon on the field become Electric type.")
          #---------------------------------------------------------------------
          when :FairyLock
            name = GameData::Move.get(:FAIRYLOCK).name
            tick = sprintf("%d/%d", value, 2)
            desc = _INTL("No Pokémon on the field can flee.")
          #---------------------------------------------------------------------
          when :Gravity
            name = GameData::Move.get(:GRAVITY).name
            tick = sprintf("%d/%d", value, 5)
            desc = _INTL("Grounds all Pokémon. Prevents midair actions. Increases accuracy.")
          #---------------------------------------------------------------------
          when :MagicRoom
            name = GameData::Move.get(:MAGICROOM).name
            tick = sprintf("%d/%d", value, 5)
            desc = _INTL("No Pokémon on the field can use their held items.")
          #---------------------------------------------------------------------
          when :WonderRoom
            name = GameData::Move.get(:WONDERROOM).name
            tick = sprintf("%d/%d", value, 5)
            desc = _INTL("All Pokémon on the field swap their Defense and Sp. Defense stats.")
          #---------------------------------------------------------------------
          when :TrickRoom
            name = GameData::Move.get(:TRICKROOM).name
            tick = sprintf("%d/%d", value, 5)
            desc = _INTL("Reverses Speed order so slower Pokémon on the field move first.")
          #---------------------------------------------------------------------
          when :MudSportField
            name = GameData::Move.get(:MUDSPORT).name
            tick = sprintf("%d/%d", value, 5)
            desc = _INTL("All Pokémon on the field take less damage from Electric moves.")
          #---------------------------------------------------------------------
          when :WaterSportField
            name = GameData::Move.get(:WATERSPORT).name
            tick = sprintf("%d/%d", value, 5)
            desc = _INTL("All Pokémon on the field take less damage from Fire moves.")
          ######################################################################
          #
          # TEAM EFFECTS - CHEERS
          #
          ######################################################################
          when :CheerOffense1
            name = _INTL("Offense Cheer 1")
            tick = sprintf("%d/%d", value, 3)
            desc = _INTL("Attacks of Pokémon on this side deal increased damage.")
          #---------------------------------------------------------------------
          when :CheerOffense2
            name = _INTL("Offense Cheer 2")
            tick = sprintf("%d/%d", value, 3)
            desc = _INTL("Attacks Pokémon on this side always trigger effects.")
          #---------------------------------------------------------------------
          when :CheerOffense3
            name = _INTL("Offense Cheer 3")
            tick = sprintf("%d/%d", value, 3)
            desc = _INTL("Attacks of Pokémon on this side bypass protections.")
          #---------------------------------------------------------------------
          when :CheerDefense1
            name = _INTL("Defense Cheer 1")
            tick = sprintf("%d/%d", value, 3)
            desc = _INTL("Pokémon on this side take reduced damage from attacks.")
          #---------------------------------------------------------------------
          when :CheerDefense2
            name = _INTL("Defense Cheer 2")
            tick = sprintf("%d/%d", value, 3)
            desc = _INTL("Pokémon on this side are immune to move effects.")
          #---------------------------------------------------------------------
          when :CheerDefense3
            name = _INTL("Defense Cheer 3")
            tick = sprintf("%d/%d", value, 3)
            desc = _INTL("Pokémon on this side will endure incoming attacks.")
          ######################################################################
          #
          # TEAM EFFECTS - ENTRY HAZARDS
          #
          ######################################################################
          when :StealthRock
            name = GameData::Move.get(:STEALTHROCK).name
            tick = _INTL("+1/1")
            desc = _INTL("Pokémon on this side take Rock type damage upon entry.")
          #---------------------------------------------------------------------
          when :Steelsurge
            name = GameData::Move.get(:GMAXSTEELSURGE).name
            tick = _INTL("+1/1")
            desc = _INTL("Pokémon on this side take Steel type damage upon entry.")
          #---------------------------------------------------------------------
          when :StickyWeb
            name = GameData::Move.get(:STICKYWEB).name
            tick = _INTL("+1/1")
            desc = _INTL("The Speed of grounded Pokémon on this side is lowered upon entry.")
          #---------------------------------------------------------------------
          when :Spikes
            name = GameData::Move.get(:SPIKES).name
            tick = sprintf("+%d/3", value)
            desc = _INTL("Grounded Pokémon on this side lose HP upon entry.")
          #---------------------------------------------------------------------
          when :ToxicSpikes
            name = GameData::Move.get(:TOXICSPIKES).name
            tick = sprintf("+%d/2", value)
            desc = _INTL("Grounded Pokémon on this side are poisoned upon entry.")
          ######################################################################
          #
          # TEAM EFFECTS - EoR DAMAGE
          #
          ######################################################################
          when :VineLash
            name = GameData::Move.get(:GMAXVINELASH).name
            tick = sprintf("%d/%d", value, 4)
            desc = _INTL("Pokémon on this side lose HP each turn. No effect on Grass types.")
          #---------------------------------------------------------------------
          when :Wildfire
            name = GameData::Move.get(:GMAXWILDFIRE).name
            tick = sprintf("%d/%d", value, 4)
            desc = _INTL("Pokémon on this side lose HP each turn. No effect on Fire types.")
          #---------------------------------------------------------------------
          when :Cannonade
            name = GameData::Move.get(:GMAXCANNONADE).name
            tick = sprintf("%d/%d", value, 4)
            desc = _INTL("Pokémon on this side lose HP each turn. No effect on Water types.")
          #---------------------------------------------------------------------
          when :Volcalith
            name = GameData::Move.get(:GMAXVOLCALITH).name
            tick = sprintf("%d/%d", value, 4)
            desc = _INTL("Pokémon on this side lose HP each turn. No effect on Rock types.")
          #---------------------------------------------------------------------  
          when :SeaOfFire
            name = _INTL("Sea of Fire")
            tick = sprintf("%d/%d", value, 4)
            desc = _INTL("Pokémon on this side lose HP each turn. No effect on Fire types.")
          ######################################################################
          #
          # TEAM EFFECTS - UTILITY
          #
          ######################################################################
          when :Rainbow
            name = _INTL("Rainbow")
            tick = sprintf("%d/%d", value, 4)
            desc = _INTL("Pokémon on this side are more likely to trigger move effects.")
          #---------------------------------------------------------------------
          when :Swamp
            name = _INTL("Swamp")
            tick = sprintf("%d/%d", value, 4)
            desc = _INTL("The Speed of the Pokémon on this side is halved.")
          #---------------------------------------------------------------------
          when :Tailwind
            name = GameData::Move.get(:TAILWIND).name
            tick = sprintf("%d/%d", value, 4)
            desc = _INTL("The Speed of the Pokémon on this side is doubled.")
          ######################################################################
          #
          # TEAM EFFECTS - DEFENSIVE
          #
          ######################################################################
          when :CraftyShield
            name = GameData::Move.get(:CRAFTYSHIELD).name
            desc = _INTL("Pokémon on this side are protected from most status moves.")
          #---------------------------------------------------------------------
          when :QuickGuard
            name = GameData::Move.get(:QUICKGUARD).name
            desc = _INTL("Pokémon on this side are protected from most priority moves.")
          #---------------------------------------------------------------------
          when :WideGuard
            name = GameData::Move.get(:WIDEGUARD).name
            desc = _INTL("Pokémon on this side are protected from most spread moves.")
          #---------------------------------------------------------------------
          when :MatBlock
            name = GameData::Move.get(:MATBLOCK).name
            desc = _INTL("Pokémon on this side are protected from most damaging moves.")
          #---------------------------------------------------------------------
          when :AuroraVeil
            name = GameData::Move.get(:AURORAVEIL).name
            tick = sprintf("%d/%d", value, 5)
            desc = _INTL("All moves deal less damage to Pokémon on this side.")
          #---------------------------------------------------------------------
          when :Reflect
            name = GameData::Move.get(:REFLECT).name
            tick = sprintf("%d/%d", value, 5)
            desc = _INTL("Physical moves deal less damage to Pokémon on this side.")
          #---------------------------------------------------------------------
          when :LightScreen
            name = GameData::Move.get(:LIGHTSCREEN).name
            tick = sprintf("%d/%d", value, 5)
            desc = _INTL("Special moves deal less damage to Pokémon on this side.")
          #---------------------------------------------------------------------
          when :Safeguard
            name = GameData::Move.get(:SAFEGUARD).name
            tick = sprintf("%d/%d", value, 5)
            desc = _INTL("Pokémon on this side are protected from status conditions.")
          #---------------------------------------------------------------------
          when :Mist
            name = GameData::Move.get(:MIST).name
            tick = sprintf("%d/%d", value, 5)
            desc = _INTL("The stats of Pokémon on this side cannot be lowered.")
          #---------------------------------------------------------------------
          when :LuckyChant
            name = GameData::Move.get(:LUCKYCHANT).name
            tick = sprintf("%d/%d", value, 5)
            desc = _INTL("Pokémon on this side are immune to critical hits.")
          ######################################################################
          #
          # POSITION EFFECTS
          #
          ######################################################################
          when :FutureSightCounter
            name = _INTL("Future Attack")
            tick = value.to_s
            data = @battle.positions[battler.index].effects[PBEffects::FutureSightMove]
            desc = _INTL("{1} will strike the Pokémon in this spot in {2} more turn(s).", GameData::Move.get(data).name, value)
          #---------------------------------------------------------------------
          when :Wish
            name = GameData::Move.get(:WISH).name
            tick = value.to_s
            data = (battler.pbOwnedByPlayer?) ? @battle.positions[battler.index].effects[PBEffects::WishAmount] : "???"
            desc = _INTL("The Pokémon in this spot will restore {1} HP in {2} more turn(s).", data, value)
          #---------------------------------------------------------------------
          when :HealingWish
            name = GameData::Move.get(:HEALINGWISH).name
            desc = _INTL("Fully heals a Pokémon switching into this spot.")
          #---------------------------------------------------------------------
          when :LunarDance
            name = GameData::Move.get(:LUNARDANCE).name
            desc = _INTL("Fully heals a Pokémon switching into this spot.")
          #---------------------------------------------------------------------
          when :ZHealing
            name = _INTL("Z-Healing")
            desc = _INTL("A Pokémon switching into this spot will recover its HP.")
          ######################################################################
          #
          # BATTLER EFFECTS - HP ALTERING
          #
          ######################################################################
          when :Endure
            name = GameData::Move.get(:ENDURE).name
            desc = _INTL("The Pokémon will survive all incoming attacks with 1 HP.")
          #---------------------------------------------------------------------
          when :Substitute
            name = GameData::Move.get(:SUBSTITUTE).name
            amt = (battler.pbOwnedByPlayer?) ? value : "???"
            desc = _INTL("A substitute with {1} HP stands in for the Pokémon.", value)
          #---------------------------------------------------------------------
          when :AquaRing
            name = GameData::Move.get(:AQUARING).name
            if battler.pbOwnedByPlayer?
              data = battler.real_totalhp / 16
              data = (hpGain * 1.3).floor if battler.hasActiveItem?(:BIGROOT)
            else
              data = "some"
            end
            desc = _INTL("The Pokémon restores {1} HP at the end of each turn.", data)
          #---------------------------------------------------------------------
          when :Ingrain
            name = GameData::Move.get(:INGRAIN).name
            if battler.pbOwnedByPlayer?
              data = battler.real_totalhp / 16
              data = (hpGain * 1.3).floor if battler.hasActiveItem?(:BIGROOT)
            else
              data = "some"
            end
            desc = _INTL("The Pokémon restores {1} HP every turn, but cannot escape.", data)
          #---------------------------------------------------------------------
          when :Toxic
            next if battler.hasActiveAbility?(:POISONHEAL) || !battler.takesIndirectDamage?
            name = _INTL("Badly Poisoned")
            desc = _INTL("Damage the Pokémon takes from its poison worsens every turn.")
          #---------------------------------------------------------------------
          when :LeechSeed
            name = GameData::Move.get(:LEECHSEED).name
            data = (battler.pbOwnedByPlayer?) ? (battler.real_totalhp / 8).floor : "some"
            desc = _INTL("Each turn, {1} leeches {2} HP from the Pokémon.", @battle.battlers[value].pbThis(true), data)
          #---------------------------------------------------------------------
          when :Curse
            name = GameData::Move.get(:CURSE).name
            data = (battler.pbOwnedByPlayer?) ? (battler.real_totalhp / 4).floor : "some"
            desc = _INTL("The Pokémon loses {1} HP at the end of each turn.", data)
          #---------------------------------------------------------------------
          when :Nightmare
            name = GameData::Move.get(:NIGHTMARE).name
            data = (battler.pbOwnedByPlayer?) ? (battler.real_totalhp / 4).floor : "some"
            desc = _INTL("The Pokémon loses {1} HP each turn it spends asleep.", data)
          #---------------------------------------------------------------------
          when :SaltCure
            name = GameData::Move.get(:SALTCURE).name
            if battler.pbOwnedByPlayer?
              fraction = (battler.pbHasType?(:STEEL) || battler.pbHasType?(:WATER)) ? 4 : 8
              data = (battler.real_totalhp / fraction).floor
            else
              data = "some"
            end
            desc = _INTL("The Pokémon loses {1} HP at the end of each turn.", data)
          #---------------------------------------------------------------------
          when :Splinters
            name = _INTL("Splinters")
            tick = sprintf("%d/%d", value, 3)
            if battler.effects[PBEffects::SplintersType]
              desc = _INTL("The Pokémon takes {1} type damage at the end of each turn.", 
              GameData::Type.get(battler.effects[PBEffects::SplintersType]).name)
            else
              desc = _INTL("The Pokémon takes damage at the end of each turn.")
            end
          ######################################################################
          #
          # BATTLER EFFECTS - MOVE/ATTRIBUTE BLOCKING
          #
          ######################################################################
          when :HealBlock
            name = GameData::Move.get(:HEALBLOCK).name
            tick = sprintf("%d/%d", value, 5)
            desc = _INTL("The Pokémon cannot use any healing effects that restores HP.")
          #---------------------------------------------------------------------
          when :Attract
            name = _INTL("Infatuation")
            desc = _INTL("The Pokémon is less likely to attack {1}.", @battle.battlers[value].pbThis(true))
          #---------------------------------------------------------------------
          when :Confusion
            name = _INTL("Confusion")
            tick = _INTL("?/?")
            desc = _INTL("The Pokémon may hurt itself in confusion instead of attacking.")
          #---------------------------------------------------------------------
          when :Outrage
            name = _INTL("Rampaging")
            tick = _INTL("?/?")
            desc = _INTL("The Pokémon rampages for a few turns. It then becomes confused.")
          #---------------------------------------------------------------------
          when :Torment
            name = GameData::Move.get(:TORMENT).name
            desc = _INTL("The Pokémon cannot use the same move twice in a row.")
          #---------------------------------------------------------------------
          when :ThroatChop
            name = GameData::Move.get(:THROATCHOP).name
            tick = sprintf("%d/%d", value, 2)
            desc = _INTL("The Pokémon cannot use any sound-based moves.")
          #---------------------------------------------------------------------
          when :Encore
            name = GameData::Move.get(:ENCORE).name
            tick = sprintf("%d/%d", value, 3)
            data = GameData::Move.get(battler.effects[PBEffects::EncoreMove]).name
            desc = _INTL("The Pokémon may only use the move {1}.", data)
          #---------------------------------------------------------------------
          when :Disable
            name = _INTL("Move Disabled")
            tick = sprintf("%d/%d", value, 4)
            data = GameData::Move.get(battler.effects[PBEffects::DisableMove]).name
            desc =_INTL("The Pokémon cannot use the move {1}.", data)
          #---------------------------------------------------------------------
          when :Taunt
            name = GameData::Move.get(:TAUNT).name
            tick = sprintf("%d/%d", value, 4)
            desc = _INTL("The Pokémon cannot use any status moves.")
          #---------------------------------------------------------------------
          when :GastroAcid
            name = _INTL("No Ability")
            desc = _INTL("The Pokémon's ability is negated.")
          #---------------------------------------------------------------------
          when :Embargo
            name = GameData::Move.get(:EMBARGO).name
            tick = sprintf("%d/%d", value, 5)
            desc = _INTL("Items cannot be used on or by the Pokémon.")
          ######################################################################
          #
          #  BATTLER EFFECTS - TYPE ALTERING
          #
          ######################################################################
          when :Charge
            name = GameData::Move.get(:CHARGE).name
            desc = _INTL("The next Electric move used by the Pokémon will double in power.")
          #---------------------------------------------------------------------
          when :Electrify
            name = GameData::Move.get(:ELECTRIFY).name
            desc = _INTL("The next move used by the Pokémon will become Electric type.")
          #---------------------------------------------------------------------
          when :MagnetRise
            name = GameData::Move.get(:MAGNETRISE).name
            tick = sprintf("%d/%d", value, 5)
            desc = _INTL("The Pokémon is airborne and immune to Ground moves.")
          #---------------------------------------------------------------------
          when :Powder
            name = GameData::Move.get(:POWDER).name
            desc = _INTL("The next Fire move used by the Pokémon will ignite and explode.")
          #---------------------------------------------------------------------
          when :TarShot
            name = GameData::Move.get(:TARSHOT).name
            desc = _INTL("The Pokémon has been made weaker to Fire type moves.")
          #---------------------------------------------------------------------
          when :SmackDown
            name = GameData::Move.get(:SMACKDOWN).name
            if battler.pbOwnedByPlayer? && battler.pbHasType?(:FLYING)
              desc = _INTL("The Pokémon is grounded and no longer immune to Ground moves.")
            else
              desc = _INTL("The Pokémon is grounded.")
            end	
          #---------------------------------------------------------------------
          when :Foresight
            name = GameData::Move.get(:FORESIGHT).name
            if battler.pbOwnedByPlayer? && battler.pbHasType?(:GHOST)
              desc = _INTL("The Pokémon's evasion boosts are ignored. No Ghost immunities.")
            else
              desc = _INTL("The Pokémon's evasion boosts are ignored.")
            end
          #---------------------------------------------------------------------
          when :MiracleEye
            name = GameData::Move.get(:MIRACLEEYE).name
            if battler.pbOwnedByPlayer? && battler.pbHasType?(:DARK)
              desc = _INTL("The Pokémon's evasion boosts are ignored. No Dark immunities.")
            else
              desc = _INTL("The Pokémon's evasion boosts are ignored.")
            end
          ######################################################################
          #
          # BATTLER EFFECTS - STAT ALTERING
          #
          ######################################################################
          when :Rage
            name = GameData::Move.get(:RAGE).name
            desc = _INTL("The Attack stat of the Pokémon increases whenever it is hit.")
          #---------------------------------------------------------------------
          when :HelpingHand
            name = GameData::Move.get(:HELPINGHAND).name
            desc = _INTL("The damage dealt with the Pokémon's next move will be increased.")
          #---------------------------------------------------------------------
          when :PowerTrick
            name = GameData::Move.get(:POWERTRICK).name
            desc = _INTL("The Attack and Defense stats of the Pokémon are swapped.")
          #---------------------------------------------------------------------
          when :LaserFocus
            name = GameData::Move.get(:LASERFOCUS).name
            tick = sprintf("%d/%d", value, 2)
            desc = _INTL("The Pokémon's next attack will be a guaranteed critical hit.")
          #---------------------------------------------------------------------
          when :Stockpile
            name = GameData::Move.get(:STOCKPILE).name
            tick = sprintf("+%d/%d", value, 3)
            desc = _INTL("The Pokémon is amassing a stockpile to use or consume.")
          #---------------------------------------------------------------------
          when :Minimize
            name = GameData::Move.get(:MINIMIZE).name
            desc = _INTL("The Pokémon takes more damage from certain moves while minimized.")
          #---------------------------------------------------------------------
          when :GlaiveRush
            name = _INTL("Vulnerable")
            tick = sprintf("%d/%d", value, 2)
            desc = _INTL("The Pokémon cannot evade and takes double damage from attacks.")
          #---------------------------------------------------------------------
          when :Telekinesis
            name = GameData::Move.get(:TELEKINESIS).name
            tick = sprintf("%d/%d", value, 3)
            desc = _INTL("The Pokémon has been made airborne, but it cannot evade attacks.")
          #---------------------------------------------------------------------
          when :LockOn
            name = GameData::Move.get(:LOCKON).name
            tick = sprintf("%d/%d", value, 2)
            data = @battle.battlers[battler.effects[PBEffects::LockOnPos]]
            desc = _INTL("The Pokémon's next move is sure to hit {1}.", data.pbThis(true))
          #---------------------------------------------------------------------
          when :Syrupy
            name = _INTL("Speed Down")
            tick = sprintf("%d/%d", value, 3)
            data = @battle.battlers[battler.effects[PBEffects::SyrupyUser]]
            desc = _INTL("Each turn, {1} lowers the Pokémon's Speed.", data.pbThis(true), value)
          #---------------------------------------------------------------------
          when :WeightChange
            name = _INTL("Weight Changed")
            desc = _INTL("The Pokémon's weight has been {1}.", (value > 0) ? "increased" : "decreased")
          ######################################################################
          #
          # BATTLER EFFECTS - TRAPPING
          #
          ######################################################################
          when :NoRetreat
            name = GameData::Move.get(:NORETREAT).name
            desc = _INTL("The Pokémon refuses to flee or switch out.")
          #---------------------------------------------------------------------
          when :JawLock
            name = GameData::Move.get(:JAWLOCK).name
            desc = _INTL("Trapped by {1}.", @battle.battlers[value].pbThis(true))
          #---------------------------------------------------------------------
          when :MeanLook
            name = GameData::Move.get(:MEANLOOK).name
            desc = _INTL("Trapped by {1}.", @battle.battlers[value].pbThis(true))
          #---------------------------------------------------------------------
          when :Octolock
            name = GameData::Move.get(:OCTOLOCK).name
            desc = _INTL("Trapped by {1}. Defense drops each turn.", @battle.battlers[value].pbThis(true))
          #---------------------------------------------------------------------
          when :Trapping
            move = battler.effects[PBEffects::TrappingMove]
            user = @battle.battlers[battler.effects[PBEffects::TrappingUser]]
            name = (move) ? GameData::Move.get(move).name : _INTL("Bound")
            tick = sprintf("%d/%d", value, 5)
            if user
              desc = _INTL("Trapped by {1}. Loses HP each turn.", user.pbThis(true))
            else
              desc = _INTL("Trapped and loses HP each turn.")
            end          
          ######################################################################
          #
          # BATTLER EFFECTS - PROTECTION
          #
          ######################################################################
          when :MagicCoat
            name = GameData::Move.get(:MAGICCOAT).name
            desc = _INTL("The Pokémon bounces back most incoming status moves.")
          #---------------------------------------------------------------------
          when :Protect
            name = GameData::Move.get(:PROTECT).name
            desc = _INTL("The Pokémon is protected from most incoming attacks.")
          #---------------------------------------------------------------------
          when :SpikyShield
            name = GameData::Move.get(:SPIKYSHIELD).name
            desc = _INTL("Protected from most moves. Contact inflicts damage.")
          #---------------------------------------------------------------------
          when :BanefulBunker
            name = GameData::Move.get(:BANEFULBUNKER).name
            desc = _INTL("Protected from most moves. Contact inflicts poison.")
          #---------------------------------------------------------------------
          when :BurningBulwark
            name = GameData::Move.get(:BURNINGBULWARK).name
            desc = _INTL("Protected from damage dealing moves. Contact inflicts a burn.")
          #---------------------------------------------------------------------
          when :KingsShield
            name = GameData::Move.get(:KINGSSHIELD).name
            desc = _INTL("Protected from damage dealing moves. Contact lowers Attack.")
          #---------------------------------------------------------------------
          when :Obstruct
            name = GameData::Move.get(:OBSTRUCT).name
            desc = _INTL("Protected from damage dealing moves. Contact lowers Defense.")
          #---------------------------------------------------------------------
          when :SilkTrap
            name = GameData::Move.get(:SILKTRAP).name
            desc = _INTL("Protected from damage dealing moves. Contact lowers Speed.")
          ######################################################################
          #
          # BATTLER EFFECTS - DELAYED ACTION
          #
          ######################################################################
          when :TwoTurnAttack 
            name = _INTL("Charging Turn")
            desc = _INTL("The Pokémon will use {1} next turn.", GameData::Move.get(value).name)
            if battler.semiInvulnerable?
              display_effects.push([_INTL("Semi-Invulnerable"), "--", _INTL("The Pokémon cannot be hit by most attacks.")])
            end
          #---------------------------------------------------------------------
          when :SkyDrop
            name = GameData::Move.get(:SKYDROP).name
            desc = _INTL("The Pokémon is being lifted in the air by {1}.", @battle.battlers[value].pbThis(true))
          #---------------------------------------------------------------------
          when :HyperBeam
            name = _INTL("Recharging")
            tick = value.to_s
            desc = _INTL("The Pokémon cannot act for {1} more turn(s).", value)
          #---------------------------------------------------------------------
          when :Yawn
            name = _INTL("Drowsy")
            tick = value.to_s
            desc = _INTL("The Pokémon will fall asleep in {1} more turn(s).", value)
          #---------------------------------------------------------------------
          when :PerishSong
            name = _INTL("Perish Count")
            tick = value.to_s
            desc = _INTL("The Pokémon will be forced to faint in {1} more turn(s).", value)
          #---------------------------------------------------------------------
          when :SlowStart
            next if !battler.hasActiveAbility?(:SLOWSTART)
            name = GameData::Ability.get(:SLOWSTART).name
            tick = value.to_s
            desc = _INTL("The Pokémon gets its act together in {1} more turn(s).", value)
          else next
          end
          tick = "--" if type == :counter && value < 0
          display_effects.push([name, tick, desc])
        end
      end
    end
    #---------------------------------------------------------------------------
    # Checks all other battlers for Jaw Lock trapping.
    @battle.allBattlers.each do |b|
      next if b.effects[PBEffects::JawLock] != battler.index
      name = GameData::Move.get(:JAWLOCK).name
      desc = _INTL("The Pokémon is trapped while latched to {1}.", b.pbThis(true))
      display_effects.push([name, "--", desc])
    end
    #---------------------------------------------------------------------------
    # Checks all opposing battlers for Imprison.
    @battle.allOtherSideBattlers(battler.index).each do |b|
	  next if !b.effects[PBEffects::Imprison]
      name = GameData::Move.get(:IMPRISON).name
      desc = _INTL("The Pokémon can't use moves known by {1}.", b.pbThis(true))
      display_effects.push([name, "--", desc])
      break
    end
    #---------------------------------------------------------------------------
    # Checks all other battlers for Uproar if the user doesn't have Soundproof.
    if !battler.hasActiveAbility?(:SOUNDPROOF)
      @battle.allBattlers.each do |b|
        next if b.effects[PBEffects::Uproar] == 0
        name = GameData::Move.get(:UPROAR).name
        tick = sprintf("%d/%d", b.effects[PBEffects::Uproar], 3)
        desc = _INTL("{1}'s uproar prevents sleeping.", b.pbThis)
        display_effects.push([name, tick, desc])
        break
      end
    end
    display_effects.uniq!
    return display_effects
  end
end