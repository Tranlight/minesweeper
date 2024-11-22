class GenMineService < ApplicationService
  private

  def initialize(board, block)
    @block = block
    @board = board
  end

  def call
    # Calculate the number of mines for this view
    total_cells = @block[:width] * @block[:height]

    return if mine_count <= 0

    # Generate random unique positions using a hash
    mine_positions = {}
    while mine_positions.size < mine_count
      random_index = rand(0...total_cells)
      mine_positions[random_index] ||= true
    end
    Mine.transaction do
      Mine.insert_all!(build_mines(mine_positions))
      @board.update!(generated_mines: @board.generated_mines + mine_count)
    end
  end

  def mine_count
    ratio = (@block[:width] * @block[:height]) / @board.size.to_f
    [(@board.total_mines * ratio).ceil, @board.total_mines - @board.generated_mines].min
  end

  def build_mines(mine_positions)
    # Map the positions to mine records for bulk insertion
    mine_positions.map do |position, _|
      {
        board_id: @board.id,
        x: position % @block[:width] + @block[:x],
        y: position / @block[:width] + @block[:y],
        block_hash: Mine.gen_block_hash(@board.id, @block[:x], @block[:y])
      }
    end
  end
end
