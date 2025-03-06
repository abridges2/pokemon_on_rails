class CreatePokemonMoves < ActiveRecord::Migration[8.0]
  def change
    create_table :pokemon_moves do |t|
      t.references :pokemon, null: false, foreign_key: true
      t.references :move, null: false, foreign_key: true
      t.integer :level_learned

      t.timestamps
    end
  end
end
