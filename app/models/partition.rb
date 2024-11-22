class Partition < ApplicationRecord
  belongs_to :board

  validates :x, :y, :width, :height, presence: true
  after_create :gen_mines

  private
  def gen_mines
    GenMineService.call(this)
  end
end
