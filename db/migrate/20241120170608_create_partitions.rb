class CreatePartitions < ActiveRecord::Migration[8.0]
  def change
    create_table :partitions do |t|
      t.integer :x
      t.integer :y
      t.integer :width
      t.integer :height
      t.references :board, null: false, foreign_key: true

      t.timestamps
    end
  end
end
