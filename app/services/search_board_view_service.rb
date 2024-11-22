class SearchBoardViewService < ApplicationService
  VIEW_WIDTH = 3 # Example; replace with actual value if dynamic
  VIEW_HEIGHT = 3 # Example; replace with actual value if dynamic

  private

  def initialize(board, rectangle_points)
    validate_inputs(board, rectangle_points)

    @board = board
    @rectangle_points = rectangle_points
  end

  def call
    # Collect rectangles that are fully within the board bounds
    search_views_including_rectangle()
  end


  def search_views_including_rectangle
    # Extract points
    x_coords = @rectangle_points.map { |point| point[0] }
    y_coords = @rectangle_points.map { |point| point[1] }
  
    # Determine the bounding box of the rectangle
    min_x = x_coords.min
    max_x = x_coords.max
    min_y = y_coords.min
    max_y = y_coords.max
  
    # Calculate the range of views that might include the rectangle
    start_view_x = (min_x / VIEW_WIDTH).floor
    end_view_x = (max_x / VIEW_WIDTH).floor
    start_view_y = (min_y / VIEW_HEIGHT).floor
    end_view_y = (max_y / VIEW_HEIGHT).floor
  
    # Collect all relevant views
    views = []
    (start_view_x..end_view_x).each do |view_x|
      (start_view_y..end_view_y).each do |view_y|
        # Calculate view area for the current view
        view_area = calculate_view_area(view_x * VIEW_WIDTH, view_y * VIEW_HEIGHT)
  
        # Add the view to the list if it intersects with the rectangle
        if view_area_intersects_rectangle?(view_area, min_x, max_x, min_y, max_y)
          views << view_area
        end
      end
    end
  
    views
  end
  
  # Helper function to check if a view intersects with the rectangle
  def view_area_intersects_rectangle?(view_area, min_x, max_x, min_y, max_y)
    view_min_x = view_area[:x]
    view_max_x = view_area[:x] + view_area[:width]
    view_min_y = view_area[:y]
    view_max_y = view_area[:y] + view_area[:height]
  
    # Check if the view overlaps with the rectangle
    view_max_x > min_x && view_min_x < max_x &&
      view_max_y > min_y && view_min_y < max_y
  end
  
  def validate_inputs(board, points)
    raise ArgumentError, 'Board must be provided' unless board
    raise ArgumentError, 'Points must be an array of [x, y] coordinates' unless points.is_a?(Array) && points.all? { |p| p.is_a?(Array) && p.size == 2 }
  end

  def view_area_within_bounds(point)
    x, y = point
    view_area = calculate_view_area(x, y)

    # Check if the view area is within board bounds
    if within_bounds?(view_area)
      view_area
    end
  end

  def calculate_view_area(point_x, point_y)
    # Calculate the top-left corner of the view area
    start_x = (point_x / VIEW_WIDTH) * VIEW_WIDTH
    start_y = (point_y / VIEW_HEIGHT) * VIEW_HEIGHT

    # Adjust the dimensions to stay within the board's boundaries
    adjusted_width = [VIEW_WIDTH, @board.width - start_x].min
    adjusted_height = [VIEW_HEIGHT, @board.height - start_y].min

    { x: start_x, y: start_y, width: adjusted_width, height: adjusted_height }
  end

  def within_bounds?(view_area)
    view_area[:x] >= 0 && view_area[:y] >= 0 &&
      view_area[:x] + view_area[:width] <= @board.width &&
      view_area[:y] + view_area[:height] <= @board.height
  end
end
