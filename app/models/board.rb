class Board < ApplicationRecord
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, :width, :height, :total_mines, presence: true
  validates :width, :height, :total_mines, numericality: { greater_than: 0 }
  validates :total_mines, numericality: { less_than_or_equal_to: :size }

  def size
    width * height
  end
end
