class PokemonSummaryScreen
  attr_accessor :locking_bypassed
  alias innates_initialize initialize
  def initialize(scene, inBattle = false)
    innates_initialize(scene, inBattle)
    @locking_bypassed = false
  end
end

class PokemonSummary_Scene
  def wrap_text(text, max_width, overlay)
    words = text.split(' ')
    lines = []
    current_line = ""
    words.each do |word|
      if overlay.text_size("#{current_line} #{word}").width > max_width
        lines << current_line.strip
        current_line = word
      else
        current_line += " #{word}"
      end
    end
    lines << current_line.strip unless current_line.empty?
    lines
  end
  
  def get_innate_lock_status(index)
    return [true, ""] if @locking_bypassed
  
    # Simply compare index to the limit we calculated in the Pokemon class
    limit = @pokemon.innate_unlock_limit
    unlocked = index < limit
  
    message = "This innate is currently locked."
    if !unlocked && lockedMethod == :level
      lvl_array = Settings::LEVELS_TO_UNLOCK.find { |e| e.is_a?(Array) && e.first == @pokemon.species }&.drop(1) || 
                Settings::LEVELS_TO_UNLOCK.last
      message = "Locked until level #{lvl_array[index]}."
    end

    return [unlocked, message]
  end

  def drawPageINNATES
    overlay = @sprites["overlay"].bitmap
    is_sv   = PluginManager.installed?("[SV] Summary Screen")
    
    if is_sv
      base_col   = Color.new(246, 198, 6)    # Gold
      shadow_col = Color.new(74, 97, 103)
      text_col   = Color.new(248, 248, 248)  # White
      text_shd   = Color.new(74, 112, 175)
      y_start, y_gap, text_x = 120, 72, 320
    else
      base_col   = Color.new(248, 248, 248)  # White
      shadow_col = Color.new(104, 104, 104)
      text_col   = Color.new(64, 64, 64)     # Dark Gray
      text_shd   = Color.new(176, 176, 176)
      y_start, y_gap, text_x = 80, 100, 362
    end

    active_innates = @pokemon.active_innates || []
    @pokemon.assign_innate_abilities if active_innates.empty?
    active_innates = @pokemon.active_innates

    textpos = []

    if is_sv
      textpos.push([_INTL("Ability"), 220, 48, :left, base_col, shadow_col])
      if @pokemon.ability
        drawButton(overlay, 286, 76, "Details", 0)
        textpos.push([@pokemon.ability.name, 320, 48, :left, text_col, text_shd])
      end
    end

    button_map = { 0 => 3, 1 => 4, 2 => 1 } # Only used for SV Details buttons

    3.times do |i|
      innate_data = GameData::Innate.try_get(active_innates[i])
      text_y = y_start + (i * y_gap)

      label_x = is_sv ? 220 : 224
      textpos.push([_INTL(" Innate {1}", i+1), label_x, text_y, :left, base_col, shadow_col])

      if innate_data
        unlocked, lock_msg = get_innate_lock_status(i)
        if unlocked
          drawInnateName(overlay, innate_data.name, text_x, text_y, 140, text_col, text_shd, Settings::SMALL_FONT_IN_SUMMARY)

          if is_sv
            drawButton(overlay, 286, text_y + 28, "Details", button_map[i])
          else
            desc = innate_data.description
            if Settings::SMALL_FONT_IN_SUMMARY
              pbSetSmallFont(overlay)
              drawFormattedTextEx(overlay, 224, text_y + 32, 282, desc, text_col, text_shd, 20)
              pbSetSystemFont(overlay)
            else
              drawTextEx(overlay, 224, text_y + 32, 282, 2, desc, text_col, text_shd)
            end
          end
        else
          # Locked State
          drawLockedInnate(overlay, text_y, text_x, lock_msg, Settings::SMALL_FONT_IN_SUMMARY)
        end
      else
        # No Innate defined
        drawInnateName(overlay, "---", text_x, text_y, 140, text_col, text_shd, Settings::SMALL_FONT_IN_SUMMARY)
      end
    end

    pbDrawTextPositions(overlay, textpos)
  end

  def drawLockedInnate(overlay, text_y, text_x, lock_message, small_font)
    base   = Color.new(175, 34, 34) # Red
    shadow = Color.new(247, 106, 106)
    pbDrawTextPositions(overlay, [["Locked", text_x, text_y, :left, base, shadow]])
    
    if small_font
      pbSetSmallFont(overlay)
      drawFormattedTextEx(overlay, 224, text_y + 32, 282, lock_message, base, shadow, 20)
      pbSetSystemFont(overlay)
    else
      drawTextEx(overlay, 224, text_y + 32, 282, 2, lock_message, base, shadow)
    end
  end

  def drawInnateName(overlay, name, text_x, text_y, max_width, base, shadow, small_font)
    if overlay.text_size(name).width > max_width
      pbSetSmallFont(overlay)
      lines = wrap_text(name, max_width, overlay)
      y_off = lines.size > 1 ? -10 : 0
      lines.each_with_index do |line, i|
        drawTextEx(overlay, text_x, text_y + y_off + (i * 20), max_width, 2, line, base, shadow)
      end
      pbSetSystemFont(overlay)
    else
      drawTextEx(overlay, text_x, text_y, max_width, 2, name, base, shadow)
    end
  end

  def pbInnatePrompt(start_index = 0)
    return unless PluginManager.installed?("[SV] Summary Screen")
    active_innates = @pokemon.active_innates || []
    total_entries  = 1 + active_innates.size
    index = start_index % total_entries

    loop do
      @sprites["promptoverlay"].bitmap.clear
      @sprites["promptoverlay"].visible = @sprites["abilitybg"].visible = true
      overlay = @sprites["promptoverlay"].bitmap

      # Data Selection
      if index == 0
        title, name, desc = _INTL("Ability"), @pokemon.ability.name, @pokemon.ability.description
      else
        innate_idx = index - 1
        innate_data = GameData::Innate.try_get(active_innates[innate_idx])
        unlocked, lock_msg = get_innate_lock_status(innate_idx)
        
        title = _INTL("Innate {1}", index)
        name  = unlocked ? innate_data.name : "???"
        desc  = unlocked ? innate_data.description : lock_msg
      end

      # Draw
      textpos = [
        [title, 256, 86, :center, Color.new(246, 198, 6), Color.new(74, 97, 103)],
        [name, 256, 118, :center, Color.new(248, 248, 248), Color.new(74, 112, 175)]
      ]
      drawButton(overlay, 180, 276, "Close", 2)
      pbDrawTextPositions(overlay, textpos)
      pbSetSmallFont(overlay)
      drawFormattedTextEx(overlay, 116, 152, 282, desc, Color.new(248, 248, 248), Color.new(74, 112, 175), 20)
      pbSetSystemFont(overlay)

      Graphics.update; Input.update; pbUpdate
      #break if Input.trigger?(Input::BACK)
      if Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        break
      end
      if Input.trigger?(Input::UP); index = (index - 1) % total_entries; pbPlayCursorSE; end
      if Input.trigger?(Input::DOWN); index = (index + 1) % total_entries; pbPlayCursorSE; end
    end
    @sprites["abilitybg"].visible = @sprites["promptoverlay"].visible = false
    Input.update
  end
end


