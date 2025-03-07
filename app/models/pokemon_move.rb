class PokemonMove < ApplicationRecord
  belongs_to :pokemon
  belongs_to :move

  validates :level_learned, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
