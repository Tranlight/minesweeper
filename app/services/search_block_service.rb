class SearchBlockService < ApplicationService
  BLOCK_WIDTH = 20 # Example; replace with actual value if dynamic
  BLOCK_HEIGHT = 20 # Example; replace with actual value if dynamic

  private

  def initialize(board, view)
    @board = board
    @view = view
    validate_inputs
  end

  def call
    min_x = [0, @view[:x]].max
    max_x = [@board.width - 1, @view[:x] + @view[:width] - 1].min
    min_y = [0, @view[:y]].max
    max_y = [@board.height - 1, @view[:y] + @view[:height] - 1].min
    
    # Calculate the range of blocks that might include the view
    first_block_x = min_x / BLOCK_WIDTH
    last_block_x = max_x / BLOCK_WIDTH
    first_block_y = min_y / BLOCK_HEIGHT
    last_block_y = max_y / BLOCK_HEIGHT

    # Collect all relevant blocks
    blocks = []
    (first_block_x..last_block_x).each do |block_x|
      (first_block_y..last_block_y).each do |block_y|
        # Calculate view area for the current view
        blocks << calculate_view_area(block_x, block_y)
      end
    end
    blocks
  end
  
  def validate_inputs
    # Validate that the board is an object with width and height attributes
    unless @board.respond_to?(:width) && @board.respond_to?(:height) &&
           @board.width.is_a?(Integer) && @board.height.is_a?(Integer) &&
           @board.width > 0 && @board.height > 0
      raise ArgumentError, "Invalid board object. It must have positive width and height."
    end
  
    # Validate that the view is a hash with required keys
    required_keys = %i[x y width height]
    unless @view.is_a?(Hash) && required_keys.all? { |key| @view.key?(key) }
      raise ArgumentError, "Invalid view object. It must be a hash containing keys: #{required_keys.join(', ')}."
    end
  
    # Validate that the view dimensions are positive integers
    unless @view.values_at(:x, :y, :width, :height).all? { |v| v.is_a?(Integer) && v >= 0 }
      raise ArgumentError, "Invalid view values. x, y, width, and height must be non-negative integers."
    end
  
    # Validate that the view does not exceed the board boundaries
    if @view[:x] + @view[:width] > @board.width || @view[:y] + @view[:height] > @board.height
      raise ArgumentError, "View dimensions exceed board boundaries."
    end
  end  

  def calculate_view_area(point_x, point_y)
    # Calculate the top-left corner of the view area
    start_x = point_x * BLOCK_WIDTH
    start_y = point_y * BLOCK_HEIGHT

    # Adjust the dimensions to stay within the board's boundaries
    adjusted_width = [BLOCK_WIDTH, @board.width - start_x].min
    adjusted_height = [BLOCK_HEIGHT, @board.height - start_y].min

    { x: start_x, y: start_y, width: adjusted_width, height: adjusted_height }
  end
end
