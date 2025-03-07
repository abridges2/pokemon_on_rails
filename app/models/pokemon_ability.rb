class PokemonAbility < ApplicationRecord
  belongs_to :pokemon
  belongs_to :ability

  validates :is_hidden, inclusion: { in: [ true, false ] }
end
