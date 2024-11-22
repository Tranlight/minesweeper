class HomeController < ApplicationController
  def dashboard
    @board = Board.new
    @recent_boards = Board.order(created_at: :desc).limit(10)
  end
end
