class RenameSpriteUrlInPokemons < ActiveRecord::Migration[8.0]
  def change
    rename_column :pokemons, :sprite_urll, :sprite_url
  end
end
