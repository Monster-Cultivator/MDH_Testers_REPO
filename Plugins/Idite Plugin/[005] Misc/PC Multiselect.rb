#===============================================================================
# Modern PC Multiselect Mode
# Credits: THE GREATEST OF ALL TIME; THE GOAT; THE MAN, THE MYTH, THE LEGEND:
# idite
#-------------------------------------------------------------------------------
# Loads after UI_PokemonStorage.
#
# ACTION/Z cycles:
#   Normal -> Quick Swap -> Multiselect -> Normal
#
# Multiselect mode:
#   USE/Confirm on unselected boxed Pokémon  = add to selection
#   BACK/Cancel on selected boxed Pokémon   = remove from selection
#   USE/Confirm on selected boxed Pokémon   = mass release menu
#   ACTION/Z on selected boxed Pokémon      = pick up all selected Pokémon
#   Change boxes with selected Pokémon      = grabs all selected Pokémon
#   USE/Confirm while holding selected mons = auto-place from hovered slot,
#                                             overflowing into later boxes
#   USE/Confirm on box name/top bar         = Select All / Deselect / Sort menu
#===============================================================================

module IditeStorageMultiselect
  ALLOW_WRAPAROUND_OVERFLOW = false

  MARKER_FILL_ALPHA   = 70
  MARKER_BORDER_ALPHA = 220

  TEXT_MAIN_COLOR   = Color.new(0, 232, 132)
  TEXT_SHADOW_COLOR = Color.new(0, 141, 80)

  SELECTED_TEXT_X = 18
  SELECTED_TEXT_Y = 18

  # Current highlight tuning from your working version.
  HIGHLIGHT_OFFSET_X = 6
  HIGHLIGHT_OFFSET_Y = 10
  HIGHLIGHT_SIZE     = 50
end

#===============================================================================
# Add third cursor graphic set: *_m
#===============================================================================
class PokemonBoxArrow < Sprite
  attr_accessor :multiselect
  attr_accessor :multiholding

  unless method_defined?(:idite_multi_initialize)
    alias idite_multi_initialize initialize
  end

  def initialize(viewport = nil)
    idite_multi_initialize(viewport)
    @multiselect  = false
    @multiholding = false
    @multi_grab_timer_start = nil

    @handsprite.addBitmap("point1m", "Graphics/UI/Storage/cursor_point_1_m")
    @handsprite.addBitmap("point2m", "Graphics/UI/Storage/cursor_point_2_m")
    @handsprite.addBitmap("grabm",   "Graphics/UI/Storage/cursor_grab_m")
    @handsprite.addBitmap("fistm",   "Graphics/UI/Storage/cursor_fist_m")
  end

  def multiGrabPulse
    @multi_grab_timer_start = System.uptime
  end

  def pbHandBitmapKey(base)
    return "#{base}m" if @multiselect
    return "#{base}q" if @quickswap
    return base
  end

  def update
    @updating = true
    super
    heldpkmn = heldPokemon
    heldpkmn&.update
    @handsprite.update
    @holding = false if !heldpkmn

    if @grabbing_timer_start
      if System.uptime - @grabbing_timer_start <= GRAB_TIME / 2
        @handsprite.changeBitmap(pbHandBitmapKey("grab"))
        self.y = @spriteY + lerp(0, 16, GRAB_TIME / 2, @grabbing_timer_start, System.uptime)
      else
        @holding = true
        @handsprite.changeBitmap(pbHandBitmapKey("fist"))
        delta_y = lerp(16, 0, GRAB_TIME / 2,
                       @grabbing_timer_start + (GRAB_TIME / 2), System.uptime)
        self.y = @spriteY + delta_y
        @grabbing_timer_start = nil if delta_y == 0
      end

    elsif @placing_timer_start
      if System.uptime - @placing_timer_start <= GRAB_TIME / 2
        @handsprite.changeBitmap(pbHandBitmapKey("fist"))
        self.y = @spriteY + lerp(0, 16, GRAB_TIME / 2, @placing_timer_start, System.uptime)
      else
        @holding = false
        @heldpkmn = nil
        @handsprite.changeBitmap(pbHandBitmapKey("grab"))
        delta_y = lerp(16, 0, GRAB_TIME / 2,
                       @placing_timer_start + (GRAB_TIME / 2), System.uptime)
        self.y = @spriteY + delta_y
        @placing_timer_start = nil if delta_y == 0
      end

    elsif @multi_grab_timer_start
      if System.uptime - @multi_grab_timer_start <= GRAB_TIME / 2
        @handsprite.changeBitmap("grabm")
        self.y = @spriteY + lerp(0, 16, GRAB_TIME / 2,
                                 @multi_grab_timer_start, System.uptime)
      else
        @handsprite.changeBitmap((@multiholding) ? "fistm" : "point1m")
        delta_y = lerp(16, 0, GRAB_TIME / 2,
                       @multi_grab_timer_start + (GRAB_TIME / 2), System.uptime)
        self.y = @spriteY + delta_y
        @multi_grab_timer_start = nil if delta_y == 0
      end

    elsif holding?
      @handsprite.changeBitmap(pbHandBitmapKey("fist"))

    elsif @multiselect && @multiholding
      @handsprite.changeBitmap("fistm")

    else
      self.x = @spriteX
      self.y = @spriteY
      if (System.uptime / 0.5).to_i.even?
        @handsprite.changeBitmap(pbHandBitmapKey("point1"))
      else
        @handsprite.changeBitmap(pbHandBitmapKey("point2"))
      end
    end

    @updating = false
  end
end

#===============================================================================
# Scene-side multiselect visuals/input
#===============================================================================
class PokemonStorageScene
  attr_reader :storage_cursor_mode

  unless method_defined?(:idite_multi_pbStartBox)
    alias idite_multi_pbStartBox pbStartBox
  end

  def pbStartBox(screen, command)
    idite_multi_pbStartBox(screen, command)
    @storage_cursor_mode = :normal
    @multi_select_slots = []
    pbEnsureMultiSelectSprite
    pbApplyCursorMode
    pbMultiSelectRedraw
  end

  #---------------------------------------------------------------------------
  # Box name/top bar menu helpers
  #---------------------------------------------------------------------------
  def pbMultiCurrentBoxSlots
    slots = []
    box = @storage.currentBox

    @storage.maxPokemon(box).times do |i|
      next if !@screen.pbMultiSelectable?(box, i)
      slots.push([box, i])
    end

    return slots
  end

  def pbMultiSelectAllCurrentBox
    @multi_select_slots ||= []
    added = 0

    pbMultiCurrentBoxSlots.each do |box, index|
      next if pbMultiSelected?(box, index)
      @multi_select_slots.push([box, index])
      added += 1
    end

    if added > 0
      pbPlayDecisionSE
    else
      pbPlayBuzzerSE
    end

    pbMultiSelectRedraw
    return added
  end

  def pbMultiDeselectCurrentBox
    box = @storage.currentBox
    before = (@multi_select_slots || []).length

    @multi_select_slots ||= []
    @multi_select_slots.delete_if { |slot| slot[0] == box }

    removed = before - @multi_select_slots.length

    if removed > 0
      pbPlayCancelSE
    else
      pbPlayBuzzerSE
    end

    pbMultiSelectRedraw
    return removed
  end

  def pbMultiForgetCurrentBoxSelections
    box = @storage.currentBox
    @multi_select_slots ||= []
    @multi_select_slots.delete_if { |slot| slot[0] == box }
    pbMultiSelectRedraw
  end

  def pbMultiBoxNameMenu
    if @screen.pbMultiHolding?
      pbPlayBuzzerSE
      pbDisplay(_INTL("Place the selected Pokémon first."))
      return
    end

    commands = [
      _INTL("Select All"),
      _INTL("Deselect Box"),
      _INTL("Sort"),
      _INTL("Cancel")
    ]

    command = pbShowCommands(_INTL("What do you want to do?"), commands)

    case command
    when 0
      added = pbMultiSelectAllCurrentBox
      pbDisplay(_INTL("Selected all Pokémon in this Box.")) if added > 0

    when 1
      removed = pbMultiDeselectCurrentBox
      pbDisplay(_INTL("Deselected this Box.")) if removed > 0

    when 2
      pbMultiSortCurrentBoxMenu
    end
  end

  def pbMultiSortCurrentBoxMenu
    commands = [
      _INTL("Type"),
      _INTL("Shiny"),
      _INTL("Dex"),
      _INTL("Cancel")
    ]

    command = pbShowCommands(_INTL("Sort this Box by what?"), commands)
    return if command < 0 || command == 3

    sort_mode = nil
    case command
    when 0 then sort_mode = :type
    when 1 then sort_mode = :shiny
    when 2 then sort_mode = :dex
    end

    return if !sort_mode

    if @screen.pbMultiSortCurrentBox(sort_mode)
      pbMultiForgetCurrentBoxSelections
      pbHardRefresh
      pbDisplay(_INTL("The Box was sorted."))
    end
  end

  #---------------------------------------------------------------------------
  # Cursor mode handling
  #---------------------------------------------------------------------------
  def pbSetQuickSwap(value)
    @storage_cursor_mode ||= :normal

    if @storage_cursor_mode == :normal && value
      pbSetStorageCursorMode(:quick)
    elsif @storage_cursor_mode == :quick && !value
      pbSetStorageCursorMode(:multi)
    elsif @storage_cursor_mode == :multi && value
      if @screen.respond_to?(:pbMultiHolding?) && @screen.pbMultiHolding?
        pbPlayBuzzerSE
        pbDisplay(_INTL("Place the selected Pokémon first."))
        pbSetStorageCursorMode(:multi)
      else
        @multi_select_slots.clear
        pbSetStorageCursorMode(:normal)
      end
    else
      pbSetStorageCursorMode(value ? :quick : :normal)
    end
  end

  def pbSetStorageCursorMode(mode)
    if mode == :multi && @screen.pbHeldPokemon
      pbPlayBuzzerSE
      pbDisplay(_INTL("You're holding a Pokémon!"))
      mode = :normal
    end

    @storage_cursor_mode = mode
    @quickswap = (mode == :quick)
    pbApplyCursorMode
    pbMultiSelectRedraw
  end

  def pbApplyCursorMode
    return if !@sprites || !@sprites["arrow"]
    arrow = @sprites["arrow"]
    arrow.quickswap    = (@storage_cursor_mode == :quick)
    arrow.multiselect  = (@storage_cursor_mode == :multi)
    arrow.multiholding = (@screen.respond_to?(:pbMultiHolding?) && @screen.pbMultiHolding?)
  end

  #---------------------------------------------------------------------------
  # Multiselect overlay drawing
  #---------------------------------------------------------------------------
  def pbEnsureMultiSelectSprite
    return if @sprites["multiselect"] && !@sprites["multiselect"].disposed?
    @sprites["multiselect"] = BitmapSprite.new(Graphics.width, Graphics.height, @boxsidesviewport)
    @sprites["multiselect"].z = 50
    pbSetSystemFont(@sprites["multiselect"].bitmap)
  end

  def pbMultiSelected?(box, index)
    @multi_select_slots ||= []
    return @multi_select_slots.any? { |slot| slot[0] == box && slot[1] == index }
  end

  def pbMultiToggleSlot(box, index)
    @multi_select_slots ||= []

    found = @multi_select_slots.index { |slot| slot[0] == box && slot[1] == index }
    if found
      @multi_select_slots.delete_at(found)
    else
      @multi_select_slots.push([box, index])
    end

    @sprites["arrow"].multiGrabPulse if @sprites["arrow"].respond_to?(:multiGrabPulse)
    pbMultiSelectRedraw
  end

  def pbMultiRemoveSlot(box, index)
    @multi_select_slots ||= []
    @multi_select_slots.delete_if { |slot| slot[0] == box && slot[1] == index }
    @sprites["arrow"].multiGrabPulse if @sprites["arrow"].respond_to?(:multiGrabPulse)
    pbMultiSelectRedraw
  end

  def pbMultiSelectClear
    @multi_select_slots ||= []
    @multi_select_slots.clear
    pbMultiSelectRedraw
  end

  def pbMultiSelectRedraw
    pbEnsureMultiSelectSprite
    sprite = @sprites["multiselect"]
    return if !sprite || sprite.disposed?

    bitmap = sprite.bitmap
    bitmap.clear

    count = 0
    count += @multi_select_slots.length if @multi_select_slots
    count = @screen.pbMultiHoldingCount if @screen.respond_to?(:pbMultiHolding?) && @screen.pbMultiHolding?

    show_count = (@storage_cursor_mode == :multi) ||
                 (@screen.respond_to?(:pbMultiHolding?) && @screen.pbMultiHolding?)

    fill   = Color.new(48, 216, 120, IditeStorageMultiselect::MARKER_FILL_ALPHA)
    border = Color.new(24, 248, 160, IditeStorageMultiselect::MARKER_BORDER_ALPHA)

    (@multi_select_slots || []).each do |box, index|
      next if box != @storage.currentBox
      next if index < 0

      icon = @sprites["box"].getPokemon(index)
      next if !icon || icon.disposed?

      x = icon.x + IditeStorageMultiselect::HIGHLIGHT_OFFSET_X
      y = icon.y + IditeStorageMultiselect::HIGHLIGHT_OFFSET_Y
      w = IditeStorageMultiselect::HIGHLIGHT_SIZE
      h = IditeStorageMultiselect::HIGHLIGHT_SIZE

      bitmap.fill_rect(x + 2, y + 2, w - 4, h - 4, fill)
      bitmap.fill_rect(x, y, w, 3, border)
      bitmap.fill_rect(x, y + h - 3, w, 3, border)
      bitmap.fill_rect(x, y, 3, h, border)
      bitmap.fill_rect(x + w - 3, y, 3, h, border)
    end

    if show_count
      pbDrawTextPositions(
        bitmap,
        [[_INTL("{1} Selected", count),
          IditeStorageMultiselect::SELECTED_TEXT_X,
          IditeStorageMultiselect::SELECTED_TEXT_Y,
          :left,
          IditeStorageMultiselect::TEXT_MAIN_COLOR,
          IditeStorageMultiselect::TEXT_SHADOW_COLOR,
          :outline]]
      )
    end
  end

  #---------------------------------------------------------------------------
  # Multiselect actions
  #---------------------------------------------------------------------------
  def pbMultiCanSelectCurrent?(selection)
    return false if selection < 0
    return false if !@screen.respond_to?(:pbMultiSelectable?)
    return @screen.pbMultiSelectable?(@storage.currentBox, selection)
  end

  def pbPrepareMultiForBoxChange
    return true if @storage_cursor_mode != :multi
    return true if @screen.pbMultiHolding?
    return true if !@multi_select_slots || @multi_select_slots.empty?

    old_current_box = @storage.currentBox

    return false if !@screen.pbMultiHoldSelected(@multi_select_slots)

    @multi_select_slots.each do |box, index|
      next if box != old_current_box
      next if !@sprites["box"]
      sprite = @sprites["box"].getPokemon(index)
      @sprites["box"].deletePokemon(index) if sprite && !sprite.disposed?
    end

    @multi_select_slots.clear
    pbApplyCursorMode
    pbMultiSelectRedraw
    return true
  end

  def pbTryPickUpMultiSelected(selection)
    return false if @storage_cursor_mode != :multi
    return false if @screen.pbMultiHolding?
    return false if selection < 0
    return false if !pbMultiSelected?(@storage.currentBox, selection)
    return false if !@multi_select_slots || @multi_select_slots.empty?

    if pbPrepareMultiForBoxChange
      @sprites["arrow"].multiGrabPulse if @sprites["arrow"].respond_to?(:multiGrabPulse)
      pbApplyCursorMode
      pbMultiSelectRedraw
      return true
    end

    return false
  end

  def pbTryPlaceMultiHeld(selection = 0)
    return false if !@screen.respond_to?(:pbMultiHolding?)
    return false if !@screen.pbMultiHolding?

    selection = 0 if !selection || selection < 0

    if @screen.pbMultiPlaceHeld(@storage.currentBox, selection)
      pbApplyCursorMode
      pbMultiSelectClear
      pbHardRefresh
      return true
    end

    pbApplyCursorMode
    pbMultiSelectRedraw
    return false
  end

  def pbTryCancelMultiHeld
    return false if !@screen.respond_to?(:pbMultiHolding?)
    return false if !@screen.pbMultiHolding?

    if pbShowCommands(
      _INTL("Put the selected Pokémon back?"),
      [_INTL("No"), _INTL("Yes")]
    ) == 1
      @screen.pbMultiReturnHeld
      pbApplyCursorMode
      pbMultiSelectClear
      pbHardRefresh
      return true
    end

    return false
  end

  def pbMultiSelectedMenu
    command = pbShowCommands(
      _INTL("What should be done with the selected Pokémon?"),
      [_INTL("Mass Release"), _INTL("Cancel")]
    )
    return if command != 0

    if @screen.pbMultiReleaseSelected(@multi_select_slots)
      pbMultiSelectClear
      pbHardRefresh
    else
      pbMultiSelectRedraw
    end
  end

  #---------------------------------------------------------------------------
  # Full override because multiselect changes USE/BACK/ACTION in box mode.
  #---------------------------------------------------------------------------
  def pbSelectBoxInternal(_party)
    selection = @selection
    pbSetArrow(@sprites["arrow"], selection)
    pbUpdateOverlay(selection)
    pbSetMosaic(selection)
    pbApplyCursorMode
    pbMultiSelectRedraw

    loop do
      Graphics.update
      Input.update

      key = -1
      key = Input::DOWN  if Input.repeat?(Input::DOWN)
      key = Input::RIGHT if Input.repeat?(Input::RIGHT)
      key = Input::LEFT  if Input.repeat?(Input::LEFT)
      key = Input::UP    if Input.repeat?(Input::UP)

      if key >= 0
        pbPlayCursorSE
        selection = pbChangeSelection(key, selection)
        pbSetArrow(@sprites["arrow"], selection)

        case selection
        when -4
          if pbPrepareMultiForBoxChange
            nextbox = (@storage.currentBox + @storage.maxBoxes - 1) % @storage.maxBoxes
            pbSwitchBoxToLeft(nextbox)
            @storage.currentBox = nextbox
          else
            selection = -1
          end

        when -5
          if pbPrepareMultiForBoxChange
            nextbox = (@storage.currentBox + 1) % @storage.maxBoxes
            pbSwitchBoxToRight(nextbox)
            @storage.currentBox = nextbox
          else
            selection = -1
          end
        end

        selection = -1 if [-4, -5].include?(selection)
        pbUpdateOverlay(selection)
        pbSetMosaic(selection)
        pbApplyCursorMode
        pbMultiSelectRedraw
      end

      self.update

      if Input.trigger?(Input::JUMPUP)
        if pbPrepareMultiForBoxChange
          pbPlayCursorSE
          nextbox = (@storage.currentBox + @storage.maxBoxes - 1) % @storage.maxBoxes
          pbSwitchBoxToLeft(nextbox)
          @storage.currentBox = nextbox
          pbUpdateOverlay(selection)
          pbSetMosaic(selection)
          pbApplyCursorMode
          pbMultiSelectRedraw
        else
          pbPlayBuzzerSE
        end

      elsif Input.trigger?(Input::JUMPDOWN)
        if pbPrepareMultiForBoxChange
          pbPlayCursorSE
          nextbox = (@storage.currentBox + 1) % @storage.maxBoxes
          pbSwitchBoxToRight(nextbox)
          @storage.currentBox = nextbox
          pbUpdateOverlay(selection)
          pbSetMosaic(selection)
          pbApplyCursorMode
          pbMultiSelectRedraw
        else
          pbPlayBuzzerSE
        end

      elsif Input.trigger?(Input::SPECIAL)
        if selection != -1
          pbPlayCursorSE
          selection = -1
          pbSetArrow(@sprites["arrow"], selection)
          pbUpdateOverlay(selection)
          pbSetMosaic(selection)
          pbMultiSelectRedraw
        end

      elsif Input.trigger?(Input::ACTION) && @command == 0
        if pbTryPickUpMultiSelected(selection)
          pbPlayDecisionSE
          next
        end

        pbPlayDecisionSE
        pbSetQuickSwap(!@quickswap)

      elsif Input.trigger?(Input::BACK)
        if @storage_cursor_mode == :multi
          if pbTryCancelMultiHeld
            next
          elsif selection >= 0 && pbMultiSelected?(@storage.currentBox, selection)
            pbPlayCancelSE
            pbMultiRemoveSlot(@storage.currentBox, selection)
            next
          elsif @multi_select_slots && !@multi_select_slots.empty?
            pbPlayCancelSE
            @multi_select_slots.clear
            pbMultiSelectRedraw
            next
          end
        end

        @selection = selection
        return nil

      elsif Input.trigger?(Input::USE)
        @selection = selection

        if @storage_cursor_mode == :multi
          if @screen.pbMultiHolding?
            if selection >= 0
              pbTryPlaceMultiHeld(selection)
            else
              pbPlayBuzzerSE
            end
            next
          end

          if selection >= 0
            if pbMultiSelected?(@storage.currentBox, selection)
              pbPlayDecisionSE
              pbMultiSelectedMenu
            elsif pbMultiCanSelectCurrent?(selection)
              pbPlayDecisionSE
              pbMultiToggleSlot(@storage.currentBox, selection)
            else
              pbPlayBuzzerSE
            end
            next

          elsif selection == -1   # Box name/top bar
            pbMultiBoxNameMenu
            next

          elsif selection == -3
            if @multi_select_slots && !@multi_select_slots.empty?
              pbPlayBuzzerSE
              pbDisplay(_INTL("Deselect the Pokémon first."))
              next
            end
            return [-3, -1]

          else
            pbPlayBuzzerSE
            next
          end
        end

        if selection >= 0
          return [@storage.currentBox, selection]
        elsif selection == -1
          return [-4, -1]
        elsif selection == -2
          return [-2, -1]
        elsif selection == -3
          return [-3, -1]
        end
      end
    end
  end
end

#===============================================================================
# Storage-side bulk movement/release/sorting
#===============================================================================
class PokemonStorageScreen
  def pbMultiSelectable?(box, index)
    return false if box < 0
    return false if box >= @storage.maxBoxes
    return false if index < 0
    return false if index >= @storage.maxPokemon(box)
    return !!@storage[box, index]
  end

  def pbMultiHolding?
    return @multiheld_entries && !@multiheld_entries.empty?
  end

  def pbMultiHoldingCount
    return 0 if !pbMultiHolding?
    return @multiheld_entries.length
  end

  def pbMultiResolveSlots(slots)
    ret = []
    seen = {}

    slots.each do |box, index|
      next if box < 0 || box >= @storage.maxBoxes
      next if index < 0 || index >= @storage.maxPokemon(box)

      key = [box, index]
      next if seen[key]
      seen[key] = true

      pokemon = @storage[box, index]
      ret.push([box, index, pokemon]) if pokemon
    end

    return ret
  end

  def pbMultiDestinationSlots(destbox, count, start_index = 0)
    ret = []
    return ret if destbox < 0 || destbox >= @storage.maxBoxes

    start_index = 0 if !start_index || start_index < 0
    start_index = 0 if start_index >= @storage.maxPokemon(destbox)

    boxes = []

    if IditeStorageMultiselect::ALLOW_WRAPAROUND_OVERFLOW
      @storage.maxBoxes.times { |offset| boxes.push((destbox + offset) % @storage.maxBoxes) }
    else
      destbox.upto(@storage.maxBoxes - 1) { |box| boxes.push(box) }
    end

    boxes.each_with_index do |box, box_i|
      first_slot = (box_i == 0) ? start_index : 0

      first_slot.upto(@storage.maxPokemon(box) - 1) do |index|
        next if @storage[box, index]
        ret.push([box, index])
        return ret if ret.length >= count
      end
    end

    return ret
  end

  def pbMultiHoldSelected(slots)
    entries = pbMultiResolveSlots(slots)

    if entries.empty?
      pbDisplay(_INTL("No Pokémon were selected."))
      return false
    end

    entries.each do |_box, _index, pokemon|
      if pokemon.mail
        pbDisplay(_INTL("Please remove the Mail from {1}.", pokemon.name))
        return false
      elsif pokemon.cannot_store
        pbDisplay(_INTL("{1} refuses to go into storage!", pokemon.name))
        return false
      end
    end

    @multiheld_entries = []

    entries.each do |box, index, pokemon|
      @multiheld_entries.push([pokemon, box, index])
      @storage[box, index] = nil
    end

    pbSEPlay("GUI storage pick up")
    @scene.pbRefresh
    return true
  end

  def pbMultiPlaceHeld(destbox, start_index = 0)
    return false if !pbMultiHolding?

    count = @multiheld_entries.length
    destinations = pbMultiDestinationSlots(destbox, count, start_index)

    if destinations.length < count
      pbDisplay(_INTL("There isn't enough room from this spot onward."))
      return false
    end

    @multiheld_entries.each_with_index do |entry, i|
      pokemon = entry[0]

      if Settings::HEAL_STORED_POKEMON
        old_ready_evo = pokemon.ready_to_evolve
        pokemon.heal
        pokemon.ready_to_evolve = old_ready_evo
      end

      box, index = destinations[i]
      @storage[box, index] = pokemon
    end

    moved_count = @multiheld_entries.length
    @multiheld_entries.clear
    @multiheld_entries = nil

    pbSEPlay("GUI storage put down")
    @scene.pbHardRefresh
    pbDisplay(_INTL("Moved {1} Pokémon.", moved_count))
    return true
  end

  def pbMultiReturnHeld
    return false if !pbMultiHolding?

    @multiheld_entries.each do |pokemon, old_box, old_index|
      if old_box >= 0 && old_box < @storage.maxBoxes &&
         old_index >= 0 && old_index < @storage.maxPokemon(old_box) &&
         !@storage[old_box, old_index]
        @storage[old_box, old_index] = pokemon
        next
      end

      fallback = pbMultiDestinationSlots(old_box, 1)
      if fallback && fallback[0]
        box, index = fallback[0]
        @storage[box, index] = pokemon
      else
        $player.party.push(pokemon) if $player.party.length < Settings::MAX_PARTY_SIZE
      end
    end

    @multiheld_entries.clear
    @multiheld_entries = nil
    @scene.pbHardRefresh
    return true
  end

  def pbMultiReleaseSelected(slots)
    entries = pbMultiResolveSlots(slots)

    if entries.empty?
      pbDisplay(_INTL("No Pokémon were selected."))
      return false
    end

    entries.each do |_box, _index, pokemon|
      if pokemon.egg?
        pbDisplay(_INTL("You can't release an Egg."))
        return false
      elsif pokemon.mail
        pbDisplay(_INTL("Please remove the Mail from {1}.", pokemon.name))
        return false
      elsif pokemon.cannot_release
        pbDisplay(_INTL("{1} refuses to leave you!", pokemon.name))
        return false
      end
    end

    return false if !pbConfirm(_INTL("Release all {1} selected Pokémon?", entries.length))
    return false if !pbConfirm(_INTL("This cannot be undone. Are you absolutely sure?"))

    released_count = 0

    entries.each do |box, index, pokemon|
      next if @storage[box, index] != pokemon
      @storage[box, index] = nil
      released_count += 1
    end

    @scene.pbMultiSelectClear if @scene.respond_to?(:pbMultiSelectClear)
    @scene.pbHardRefresh

    pbDisplay(_INTL("{1} Pokémon were released.", released_count))
    return true
  end

  #---------------------------------------------------------------------------
  # Sorting
  #---------------------------------------------------------------------------
  def pbMultiPrimaryTypeSortValue(pokemon)
    return 9999 if !pokemon

    type = nil
    type = pokemon.types[0] rescue nil if pokemon.respond_to?(:types)
    type = pokemon.type1 rescue nil if !type && pokemon.respond_to?(:type1)
    return 9999 if !type

    type_data = GameData::Type.get(type) rescue nil
    return 9999 if !type_data

    return type_data.icon_position.to_i if type_data.respond_to?(:icon_position)

    begin
      keys = GameData::Type.keys
      return keys.index(type) || 9999
    rescue
      return 9999
    end
  end

  def pbMultiDexSortValue(pokemon)
    return 999_999 if !pokemon

    species_data = nil

    begin
      species_data = GameData::Species.get_species_form(pokemon.species, pokemon.form)
    rescue
      species_data = nil
    end

    begin
      species_data = GameData::Species.get(pokemon.species) if !species_data
    rescue
      species_data = nil
    end

    return 999_999 if !species_data

    return species_data.pokedex_number.to_i if species_data.respond_to?(:pokedex_number)
    return species_data.id_number.to_i      if species_data.respond_to?(:id_number)

    begin
      keys = GameData::Species.keys
      return keys.index(pokemon.species) || 999_999
    rescue
      return 999_999
    end
  end

  def pbMultiSortCurrentBox(sort_mode)
    box = @storage.currentBox
    return false if box < 0 || box >= @storage.maxBoxes

    pokemon_entries = []

    @storage.maxPokemon(box).times do |i|
      pokemon = @storage[box, i]
      next if !pokemon
      pokemon_entries.push([pokemon, i])
    end

    if pokemon_entries.length <= 1
      pbDisplay(_INTL("There aren't enough Pokémon to sort."))
      return false
    end

    case sort_mode
    when :type
      pokemon_entries.sort_by! do |pokemon, original_index|
        [
          pbMultiPrimaryTypeSortValue(pokemon),
          pbMultiDexSortValue(pokemon),
          original_index
        ]
      end

    when :shiny
      pokemon_entries.sort_by! do |pokemon, original_index|
        [
          (pokemon.shiny? ? 0 : 1),
          pbMultiDexSortValue(pokemon),
          original_index
        ]
      end

    when :dex
      pokemon_entries.sort_by! do |pokemon, original_index|
        [pbMultiDexSortValue(pokemon), original_index]
      end

    else
      return false
    end

    @storage.maxPokemon(box).times do |i|
      @storage[box, i] = nil
    end

    pokemon_entries.each_with_index do |entry, i|
      pokemon = entry[0]
      @storage[box, i] = pokemon
    end

    return true
  end
end

#===============================================================================
# Multiselect Party Tab Disable Patch
#-------------------------------------------------------------------------------
# Prevents the multiselect hand from being used while the party tab is open.
# Party tab ACTION/Z becomes:
#   Normal <-> Quick Swap
# instead of:
#   Normal -> Quick Swap -> Multiselect
#===============================================================================

class PokemonStorageScene
  unless method_defined?(:idite_multi_partytab_pbShowPartyTab)
    alias idite_multi_partytab_pbShowPartyTab pbShowPartyTab
  end

  unless method_defined?(:idite_multi_partytab_pbHidePartyTab)
    alias idite_multi_partytab_pbHidePartyTab pbHidePartyTab
  end

  def pbShowPartyTab
    @idite_multi_party_tab_active = true

    # If something somehow opened the party tab while in multiselect mode,
    # force the cursor back to normal and clear the visual selection.
    if @storage_cursor_mode == :multi
      @multi_select_slots&.clear
      pbSetStorageCursorMode(:normal)
    else
      pbApplyCursorMode if respond_to?(:pbApplyCursorMode)
      pbMultiSelectRedraw if respond_to?(:pbMultiSelectRedraw)
    end

    idite_multi_partytab_pbShowPartyTab
  end

  def pbHidePartyTab
    idite_multi_partytab_pbHidePartyTab

    @idite_multi_party_tab_active = false
    pbApplyCursorMode if respond_to?(:pbApplyCursorMode)
    pbMultiSelectRedraw if respond_to?(:pbMultiSelectRedraw)
  end

  def pbPartyTabActiveForMultiselect?
    return !!@idite_multi_party_tab_active
  end

  def pbSetQuickSwap(value)
    @storage_cursor_mode ||= :normal

    #---------------------------------------------------------------------------
    # Party tab: disable multiselect entirely.
    # ACTION/Z only toggles Normal <-> Quick Swap.
    #---------------------------------------------------------------------------
    if pbPartyTabActiveForMultiselect?
      @multi_select_slots&.clear
      pbSetStorageCursorMode(value ? :quick : :normal)
      return
    end

    #---------------------------------------------------------------------------
    # Box view: keep the normal 3-mode cycle.
    #---------------------------------------------------------------------------
    if @storage_cursor_mode == :normal && value
      pbSetStorageCursorMode(:quick)
    elsif @storage_cursor_mode == :quick && !value
      pbSetStorageCursorMode(:multi)
    elsif @storage_cursor_mode == :multi && value
      if @screen.respond_to?(:pbMultiHolding?) && @screen.pbMultiHolding?
        pbPlayBuzzerSE
        pbDisplay(_INTL("Place the selected Pokémon first."))
        pbSetStorageCursorMode(:multi)
      else
        @multi_select_slots.clear
        pbSetStorageCursorMode(:normal)
      end
    else
      pbSetStorageCursorMode(value ? :quick : :normal)
    end
  end
end