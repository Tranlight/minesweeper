class GenViewService < ApplicationService
  private

  def initialize(board, view)
    validate_inputs(board, view)

    @board = board
    @view = view
  end

  def call
    view_points = generate_view_points(@view)
    partitions = fetch_or_create_partitions(view_points)
    mines = fetch_mines(partitions)
    build_mine_grid(@view, mines)
  end

  def validate_inputs(board, view)
    # Validate the board
    raise ArgumentError, 'Board must be a valid object' unless board.is_a?(Board) && board.id.present?

    # Validate the view object
    raise ArgumentError, 'View must be a hash with :x, :y, :width, :height' unless view.is_a?(Hash)
    required_keys = [:x, :y, :width, :height]
    missing_keys = required_keys - view.keys
    raise ArgumentError, "View is missing keys: #{missing_keys.join(', ')}" unless missing_keys.empty?

    # Further validation for the view dimensions (optional, based on your requirements)
    raise ArgumentError, 'Invalid view dimensions' if view[:width].to_i <= 0 || view[:height].to_i <= 0
  end

  def generate_view_points(view)
    x, y, width, height = view.values_at(:x, :y, :width, :height)
    [
      [x, y],
      [x + width, y],
      [x, y + height],
      [x + width, y + height]
    ]
  end

  def fetch_or_create_partitions(view_points)
    partitions = SearchPartitionService.call(@board, view_points)
    Partition.transaction do
      partitions.map do |partition|
        Partition.find_or_create_by!(board_id: @board.id, **partition)
      end
    end
  end

  def fetch_mines(board_views)
    Mine.select(:x, :y).where(board_view_id: board_views.map(&:id))
  end

  def build_mine_grid(view, mines)
    height, width = view.values_at(:height, :width)
    grid = Array.new(height) { Array.new(width, 0) }

    mines.each do |mine|
      map_mine_to_grid(grid, mine, view)
    end

    grid
  end

  def map_mine_to_grid(grid, mine, view)
    x, y = mine.x, mine.y
    view_x, view_y, view_width, view_height = view.values_at(:x, :y, :width, :height)

    return unless x.between?(view_x, view_x + view_width - 1) &&
                  y.between?(view_y, view_y + view_height - 1)

    grid_x = x - view_x
    grid_y = y - view_y
    grid[grid_y][grid_x] = 1
  end
end