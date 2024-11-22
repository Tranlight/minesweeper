class BoardView < ApplicationRecord
  belongs_to :board

  validates :x, :y, :width, :height, presence: true
  after_create :place_random_mines

  def place_random_mines
    Mine.where(board_view_id: self.id).delete_all

    # Calculate the number of mines for this view
    total_cells = self.width * self.height
    total_board_cells = self.board.width * self.board.height
    remain_mines = self.board.total_mines - self.board.generated_mines
    mine_count = (self.board.total_mines.to_f * (self.width * self.height) / total_board_cells).ceil

    return if mine_count <= 0

    # Generate random unique positions using a hash
    selected_positions = {}
    while selected_positions.size < mine_count
      random_index = rand(0...total_cells)
      selected_positions[random_index] ||= true
    end

    # Map the positions to mine records for bulk insertion
    mine_positions = selected_positions.keys.map do |index|
      {
        board_view_id: self.id,
        x: index % self.width + self.x,
        y: (index / self.width) + self.y
      }
    end
    Mine.transaction do
      Mine.insert_all(mine_positions)
    end

    # Update the board's generated mine count
    self.board.increment!(:generated_mines, mine_positions.size)
  end
end
