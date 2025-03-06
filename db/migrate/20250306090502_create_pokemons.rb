class CreatePokemons < ActiveRecord::Migration[8.0]
  def change
    create_table :pokemons do |t|
      t.string :name
      t.float :height
      t.float :weight
      t.integer :base_experience
      t.string :species
      t.string :sprite_urll

      t.timestamps
    end
  end
end
