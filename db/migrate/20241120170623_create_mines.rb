class CreateMines < ActiveRecord::Migration[8.0]
  def change
    create_table :mines do |t|
      t.integer :x
      t.integer :y
      t.references :partition, null: false, foreign_key: true

      t.timestamps
    end
  end
end
