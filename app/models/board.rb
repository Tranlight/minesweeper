class Board < ApplicationRecord
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, :width, :height, :total_mines, presence: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :width, :height, :total_mines, numericality: {
    only_integer: true, greater_than: 0
  }
  validates :width, :height, numericality: {
    only_integer: true, greater_than: 0, less_than: 2_147_483_647
  }
  validates :total_mines, numericality: { less_than_or_equal_to: :size }

  has_many :mines

  def size
    width * height
  end
end
