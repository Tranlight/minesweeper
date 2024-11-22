# Constants
total_items = 1_000
board_size = 1_000
subboard_size = 30
subboards_per_row = board_size / subboard_size
subboards_per_column = board_size / subboard_size
total_subboards = subboards_per_row * subboards_per_column

# Initialize an array to hold the item counts for each subboard
subboard_item_counts = Array.new(total_subboards, 0)

# Function to simulate the distribution of items
def distribute_items_randomly(total_items, total_subboards)
  items_left = total_items
  subboard_item_counts = Array.new(total_subboards, 0)
  
  # Randomly distribute items
  while items_left > 0
    random_subboard = rand(total_subboards) # Random subboard index
    subboard_item_counts[random_subboard] += 1
    items_left -= 1
  end

  subboard_item_counts
end

# Example usage of random distribution
subboard_item_counts = distribute_items_randomly(total_items, total_subboards)

# Output first 10 subboard item counts as a sample
puts subboard_item_counts.sum
print subboard_item_counts

