class CreatePokemonAbilities < ActiveRecord::Migration[8.0]
  def change
    create_table :pokemon_abilities do |t|
      t.references :pokemon, null: false, foreign_key: true
      t.references :ability, null: false, foreign_key: true
      t.boolean :is_hidden

      t.timestamps
    end
  end
end
