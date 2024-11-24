class Board < ApplicationRecord
  include MessageFormattable
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, :width, :height, :total_mines, presence: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :width, :height, :total_mines, numericality: {
    only_integer: true, greater_than: 0
  }
  validates :width, :height, numericality: {
    less_than_or_equal_to: LIMIT_INTEGER,
    message: delimited_count_error_message(:less_than_or_equal_to)
  }
  validates :total_mines, numericality: {
    less_than_or_equal_to: :size,
    message: delimited_count_error_message(:less_than_or_equal_to)
  }

  has_many :mines

  def size
    width * height
  end
end
