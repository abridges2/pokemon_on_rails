class PokemonType < ApplicationRecord
  belongs_to :pokemon
  belongs_to :type

  validates :slot, numericality: { greater_than: 0 }
end
