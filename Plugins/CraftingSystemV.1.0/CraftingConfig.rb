# ===============================================================================
# File: Plugins/CraftingSystem/CraftingConfig.rb
# Central configuration module for the crafting system UI and behavior
# ===============================================================================

#===============================================================================
# CraftingUIConfig Module - Configuration constants and utility methods
# Contains all customizable settings for layout, colors, graphics, and calculations
#===============================================================================

module CraftingUIConfig

  #===============================================================================
  # UI Layout Dependencies:
  # Recipe Window: Controls text positioning, visible count, cursor, and scrolling
  # Category Window: Controls navigation arrows and category text positioning  
  # Ingredients Window: Controls title, ingredient list, and icon positioning
  #===============================================================================

  #===============================================================================
  # Category Configuration
  #===============================================================================
 
  # List of all available categories - modify this to add/remove categories
  # First category should typically be "All Items" for showing everything
  CATEGORIES = [
    "All Items",
    "Evolution Items", 
    "Materials",
	"Held Items",
	"Key Items",
  ].freeze

  #===============================================================================
  # Recipe Window Configuration
  #===============================================================================
  
  # Number of recipes visible at once (window auto-sizes with built-in scrolling)
  RECIPE_WINDOW_MAX_VISIBLE = 6
  
  # Whether to scale font size based on window width
  RECIPE_TEXT_SCALING_ENABLED = true
  
  # Recipe window position on screen
  RECIPE_WINDOW_X = 30         # X position of recipe list window
  RECIPE_WINDOW_Y = 32         # Y position of recipe list window
  
  # Internal margins and spacing for recipe window content
  RECIPE_WINDOW_CONTENT_MARGIN = 0         # Margin inside recipe window for content
  RECIPE_ROW_EXTRA_SPACING = 0            # Extra pixels between each recipe row

  # Text positioning within recipe items
  RECIPE_TEXT_X_OFFSET = 8     # Horizontal offset from margin
  RECIPE_TEXT_Y_OFFSET = 2     # Vertical offset from top edge
  RECIPE_TEXT_MAX_CHAR_CALC = 40  # Used in character limit calculation
  QUANTITY_TEXT_RIGHT_MARGIN = 8   # Right margin for quantity text (x2, x3, etc.)
  
  #===============================================================================
  # Cursor Configuration
  #===============================================================================
  
  CURSOR_X_OFFSET = 0         # Horizontal cursor adjustment
  CURSOR_Y_OFFSET = 0       # Vertical cursor adjustment
  
  #===============================================================================
  # Category Window Configuration
  #===============================================================================
  
  CATEGORY_WINDOW_X = 50                       # X position of category window
  CATEGORY_WINDOW_Y = 230                      # Y position of category window
  CATEGORY_ARROW_SPACING = 5                   # Distance between arrows and window
  
  #===============================================================================
  # Ingredients Display Configuration
  #===============================================================================
  
  INGREDIENTS_WINDOW_X = 265                # X position of ingredients window
  INGREDIENTS_WINDOW_Y = 30                # Y position of ingredients window
  INGREDIENTS_WINDOW_PADDING = 8           # Internal padding for ingredients window
  INGREDIENTS_TITLE_Y_OFFSET = 16          # Y offset for "Ingredients" title
  INGREDIENTS_LIST_Y_OFFSET = 42           # Y offset for ingredient list
  
  INGREDIENT_SPACING = 28                  # Vertical spacing between ingredients
  INGREDIENT_ICON_SIZE = 24                # Size of ingredient icons (24x24)
  INGREDIENT_TEXT_X_OFFSET = 28            # X offset for ingredient text from icon
  INGREDIENT_TEXT_Y_OFFSET = 4             # Y offset for ingredient text from icon
  INGREDIENT_FONT_SIZE_REDUCTION = 2       # Font size reduction for ingredients
  
  #===============================================================================
  # Result Item Display Configuration
  #===============================================================================
  
  RESULT_ITEM_PANEL_X = 24             # X position of result item icon
  RESULT_ITEM_PANEL_Y = 313            # Y position of result item icon
  RESULT_ITEM_ICON_SIZE = 48           # Size of result item icon
  
  RESULT_TEXT_X_OFFSET = 80            # X offset for result text from icon
  RESULT_TEXT_Y = 300                  # Y position for result item text
  RESULT_DESC_LINE_HEIGHT = 25         # Line height for description text
  RESULT_DESC_MAX_CHARS = 35           # Max characters per description line
  RESULT_DESC_WRAP_THRESHOLD = 40      # Description length before word wrapping
  
  #===============================================================================
  # Category Display Configuration
  #===============================================================================
  
  CATEGORY_TEXT_Y_OFFSET = -8          # Y offset for category text from center
  ARROW_OPACITY_DIM = 128              # Opacity for dimmed arrows (at ends)
  ARROW_OPACITY_BRIGHT = 255           # Opacity for active arrows

  #===============================================================================
  # Window Background Positioning
  #===============================================================================
  
  DESC_WINDOW_Y = 280                  # Y position of description background
  
  #===============================================================================
  # Font Configuration
  #===============================================================================
  
  BASE_FONT_SIZE = 10                   # Offset from system font (4 = 4 pixels larger)
  INGREDIENT_MIN_FONT_SIZE = 16        # Minimum readable font size for ingredients
  
  #===============================================================================
  # Story Flag/Switch Configuration
  # Add your custom switches here for unlock conditions
  #===============================================================================
  
  STORY_SWITCHES = {
    "GARDEVOIR_LOVE" => 801,
	"EEVEE_1_LOVE" => 802,
	"NOIVERN_LOVE" => 803,
	"NINETALES_LOVE" => 804,
	"MAWILE_LOVE" => 805,
	"A_NINETALES_LOVE" => 806,
	"CORVIKNIGHT_LOVE" => 807,
	"LURANTIS_LOVE" => 808,
	"DRAGONAIR_LOVE" => 809,
	"SNEASEL_LOVE" => 810,
	"WHIMSICOTT_LOVE" => 811,
	"LUXRAY_LOVE" => 812,
	"MISMAGIUS_LOVE" => 813,
	"BRAIXEN_LOVE" => 814,
	"CINDERACE_LOVE" => 815,
	"MEOWSCARADA_LOVE" => 816,
	"PRIMARINA_LOVE" => 817,
	"LUSAMINE_LILLIE_LOVE" => 944,
    # Add more switches here as needed:
    # "TEAM_ROCKET_DEFEATED" => 53,
    # "NATIONAL_DEX_UNLOCKED" => 54,
    # "POST_GAME_UNLOCKED" => 55,
  }.freeze
  
  #===============================================================================
  # Color Configuration
  #===============================================================================
  
  # Recipe availability status colors
  COLOR_CRAFTABLE = Color.new(0, 120, 0)        # Green - can craft now
  COLOR_LOCKED = Color.new(80, 80, 80)          # Gray - unlocked but missing materials
  COLOR_UNAVAILABLE = Color.new(150, 150, 150)  # Light gray - locked/unavailable
  
  # Ingredient availability colors
  COLOR_AVAILABLE = Color.new(0, 150, 0)        # Green - have enough
  COLOR_MISSING = Color.new(150, 50, 50)        # Red - missing ingredients
  
  # General interface colors
  COLOR_TEXT = Color.new(248, 248, 248)         # White text
  COLOR_SHADOW = Color.new(0, 0, 0)             # Black text shadow/outline
  COLOR_CANCEL = Color.new(60, 60, 60)          # Cancel option color
  COLOR_TITLE = Color.new(0, 0, 0)              # Title text color (ingredients)
  
  #===============================================================================
  # Graphics Paths
  #===============================================================================
  
  # UI element graphics
  CURSOR_GRAPHIC = "Graphics/UI/Crafting/cursor"
  BACKGROUND_GRAPHIC = "Graphics/UI/Crafting/background.png"
  INGREDIENTS_BG_GRAPHIC = "Graphics/UI/Crafting/ingredients_window.png"
  RECIPE_BG_GRAPHIC = "Graphics/UI/Crafting/recipe_window.png"
  CATEGORY_BG_GRAPHIC = "Graphics/UI/Crafting/category_window.png"
  DESC_BG_GRAPHIC = "Graphics/UI/Crafting/craftable_description.png"
  ARROW_LEFT_GRAPHIC = "Graphics/UI/Crafting/arrow_left.png"
  ARROW_RIGHT_GRAPHIC = "Graphics/UI/Crafting/arrow_right.png"
  
  # Item graphics directory
  ITEM_GRAPHICS_PATH = "Graphics/Items/"  # Path to item icon graphics
  
  #===============================================================================
  # Performance Configuration
  #===============================================================================
  
  # Whether to refresh ingredients display when recipe selection changes
  REFRESH_ON_INDEX_CHANGE = true

  #===============================================================================
  # Utility Methods
  #===============================================================================

  # Load graphic dimensions and cache results for performance
  def self.get_asset_dimensions(graphic_path)
    @dimension_cache ||= {}
    return @dimension_cache[graphic_path] if @dimension_cache[graphic_path]
    
    begin
      temp_bitmap = Bitmap.new(graphic_path)
      dimensions = { width: temp_bitmap.width, height: temp_bitmap.height }
      temp_bitmap.dispose
      @dimension_cache[graphic_path] = dimensions
      return dimensions
    rescue => e
      puts "Warning: Could not load asset dimensions for #{graphic_path}: #{e.message}"
      return { width: 20, height: 20 }  # Safe fallback dimensions
    end
  end

  # Set up font properties consistently across all bitmaps - simplified approach
  def self.setup_crafting_font(bitmap, enable_scaling = false, scale_factor = 1.0)
    begin
      # Try to set Power Clear font directly
      bitmap.font.name = "Power Clear"
      
      # If that doesn't work, try pbSetSystemFont (which might already be configured for Power Clear)
      if bitmap.font.name != "Power Clear"
        pbSetSystemFont(bitmap)
      end
    rescue => e
      pbSetSystemFont(bitmap)  # Fallback to Pokemon Essentials system font
    end
    
    # Set base font size (not add to it) to prevent incremental growth
    base_size = 20  # Default Pokemon Essentials font size
    bitmap.font.size = base_size + BASE_FONT_SIZE
    
    # Apply scaling if enabled and factor is not 1.0
    if enable_scaling && scale_factor != 1.0
      current_size = bitmap.font.size
      new_size = (current_size * scale_factor).round
      bitmap.font.size = [new_size, 12].max  # Minimum readable size
    end
  end

  # Calculate optimal row height to fit recipes in available window space
  def self.calculate_row_height(window_height, content_margin, recipes_per_page, extra_spacing = 0)
    usable_height = window_height - (content_margin * 2)
    max_possible_row_height = (usable_height / recipes_per_page).floor
    
    # Apply safety margin and extra spacing
    row_height_with_margin = max_possible_row_height - 3  # 3px safety margin
    row_height_with_spacing = row_height_with_margin + extra_spacing
    actual_row_height = [row_height_with_spacing, 20].max  # Minimum 20px
    
    # Ensure total content height doesn't exceed usable space
    total_content_height = recipes_per_page * actual_row_height
    if total_content_height > usable_height
      actual_row_height = (usable_height / recipes_per_page).floor
    end
    
    actual_row_height
  end

  # Calculate font scaling factor based on window width
  def self.calculate_font_scale_factor(window_width, reference_width = 250)
    return 1.0 unless RECIPE_TEXT_SCALING_ENABLED
    scale = window_width.to_f / reference_width
    [[scale, 0.8].max, 1.2].min  # Clamp between 0.8x and 1.2x
  end

  # Get item data with fallback for missing items
  def self.get_item_data(item_symbol)
    begin
      item_data = GameData::Item.get(item_symbol)
      {
        name: item_data.name,
        description: item_data.description || "A crafted item.",
        player_quantity: $bag.quantity(item_symbol)
      }
    rescue => e
      puts "Warning: Could not get item data for #{item_symbol}: #{e.message}"
      # Fallback data for items that don't exist in GameData
      {
        name: item_symbol.to_s.capitalize,
        description: "A crafted item.",
        player_quantity: 0
      }
    end
  end
end