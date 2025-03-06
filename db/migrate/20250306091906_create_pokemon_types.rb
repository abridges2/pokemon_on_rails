class CreatePokemonTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :pokemon_types do |t|
      t.references :pokemon, null: false, foreign_key: true
      t.references :type, null: false, foreign_key: true
      t.integer :slot

      t.timestamps
    end
  end
end
