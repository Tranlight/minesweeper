class BoardsController < ApplicationController
  include ViewSettable
  before_action :set_board, only: [ :show ]

  def create
    @board = Board.new(board_params)

    if @board.save
      redirect_to board_path(@board), notice: "Board created successfully!"
    else
      @recent_boards = Board.order(created_at: :desc).limit(10)
      render template: "home/dashboard", status: :unprocessable_entity
    end
  end

  def show
    @board = Board.find(params[:id])
    @view_grid = GenViewService.call(@board, current_view)
  end

  def index
    @boards = Board.order(created_at: :desc)
    @boards = @boards.page(params[:page]).per(10)
  end

  private

  def board_params
    params.require(:board).permit(:name, :email, :width, :height, :total_mines)
  end

  def set_board
    @board = Board.find(params[:id])
  end
end
