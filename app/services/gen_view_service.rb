class GenViewService < ApplicationService
  private

  def initialize(board, view)
    validate_inputs(board, view)

    @board = board
    @view = view
  end

  def call
    blocks = generate_blocks_hash
    mines = Mine.where(board_id: @board, block_hash: blocks.keys)
    new_block_hashes = blocks.keys - mines.pluck(:block_hash).uniq
    generate_new_mines(blocks, new_block_hashes)

    build_mine_grid(@view, mines)
  end

  private

  def generate_blocks_hash
    SearchBlockService.call(@board, @view).each_with_object({}) do |block, hash|
      hash[Mine.gen_block_hash(@board.id, block[:x], block[:y])] = block
    end
  end

  def generate_new_mines(blocks, new_block_hashes)
    new_block_hashes.each { |hash| GenMineService.call(@board, blocks[hash]) }
  end

  def validate_inputs(board, view)
    # Validate the board
    raise ArgumentError, "Board must be a valid object" unless board.is_a?(Board) && board.id.present?

    # Validate the view object
    raise ArgumentError, "View must be a hash with :x, :y, :width, :height" unless view.is_a?(Hash)
    required_keys = [ :x, :y, :width, :height ]
    missing_keys = required_keys - view.keys
    raise ArgumentError, "View is missing keys: #{missing_keys.join(', ')}" unless missing_keys.empty?

    # Further validation for the view dimensions (optional, based on your requirements)
    raise ArgumentError, "Invalid view dimensions" if view[:width].to_i <= 0 || view[:height].to_i <= 0
  end

  def build_mine_grid(view, mines)
    height, width = view.values_at(:height, :width)
    grid = Array.new(height) { Array.new(width, 0) }
    mines.each do |mine|
      map_mines_to_grid(grid, mine, view)
    end

    grid
  end

  def map_mines_to_grid(grid, mine, view)
    x, y = mine.x, mine.y
    view_x, view_y, view_width, view_height = view.values_at(:x, :y, :width, :height)

    return unless x.between?(view_x, view_x + view_width - 1) &&
                  y.between?(view_y, view_y + view_height - 1)

    grid_x = x - view_x
    grid_y = y - view_y
    grid[grid_y][grid_x] = 1
  end
end
