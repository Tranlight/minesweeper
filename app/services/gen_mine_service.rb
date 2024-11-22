class GenMineService < ApplicationService
  private

  def initialize(partition)
    @partition = partition
    @board = partition.board
  end

  def call
    # Calculate the number of mines for this view
    total_cells = @partition.width * @partition.height
    total_board_cells = @board.width * @board.height

    return if mine_count <= 0

    # Generate random unique positions using a hash
    mine_positions = {}
    while mine_positions.size < mine_count
      random_index = rand(0...total_cells)
      mine_positions[random_index] ||= true
    end

    Mine.insert_all(build_mines(mine_positions))
  end

  def mine_count
    ratio = (@partition.width * @partition.height) / total_board_cells.to_f
    (@board.total_mines * ratio).ceil
  end

  def build_mines(mine_positions)
    # Map the positions to mine records for bulk insertion
    mine_positions.each_with_object([]) do |index, positions|
      positions << {
        partition_id: @partition.id,
        x: index % @partition.width + @partition.x,
        y: (index / @partition.width) + @partition.y
      }
    end
  end
