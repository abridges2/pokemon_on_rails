class CreateMoves < ActiveRecord::Migration[8.0]
  def change
    create_table :moves do |t|
      t.string :name
      t.integer :accuracy
      t.integer :power
      t.references :type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
