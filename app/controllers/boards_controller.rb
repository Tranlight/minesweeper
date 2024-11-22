class BoardsController < ApplicationController
  before_action :set_board, only: [:show]

  def create
    @board = Board.new(board_params)

    if @board.save
      redirect_to board_path(@board), notice: "Board created successfully!"
    else
      render :new
    end
  end

  def show
    @board = Board.find(params[:id])
    @view_grid = GenViewService.call(@board, current_view)
  end

  def index
    @boards = Board.order(created_at: :desc).limit(10)
  end

  private

  def board_params
    params.require(:board).permit(:name, :email, :width, :height, :total_mines)
  end

  def set_board
    @board = Board.find(params[:id])
  end

  def init_view
    view_width = [20, @board.width].min
    view_height = [10, @board.height].min
    { x: 0, y: 0, width: view_width, height: view_height }
  end

  def current_view
    session[:current_view] ||= init_view
    direction = params[:direction]
  
    unless direction
      session[:current_view] = init_view
      return session[:current_view].symbolize_keys
    end
  
    current_view = session[:current_view].symbolize_keys
  
    current_view = move_view(current_view, direction)

    # Save updated and clamped view in session
    session[:current_view] = clamp_view(current_view)
    session[:current_view].symbolize_keys
  end

  def move_view(current_view, direction)
    case direction
    when "up"
      current_view[:y] -= current_view[:height]
    when "down"
      current_view[:y] += current_view[:height]
    when "left"
      current_view[:x] -= current_view[:width]
    when "right"
      current_view[:x] += current_view[:width]
    end
  
    current_view
  end
  
  def clamp_view(current_view)
    # Define boundaries for the view
    min_x, max_x = 0, @board.width
    min_y, max_y = 0, @board.height
  
    # Ensure the view fits within the bounds
    current_view[:x] = [[current_view[:x], max_x - current_view[:width]].min, min_x].max
    current_view[:y] = [[current_view[:y], max_y - current_view[:height]].min, min_y].max
  
    # If the view size exceeds the board, adjust it to fit
    current_view[:width] = [current_view[:width], @board.width].min
    current_view[:height] = [current_view[:height], @board.height].min
  
    current_view
  end
end
