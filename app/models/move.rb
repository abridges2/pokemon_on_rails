class Move < ApplicationRecord
  belongs_to :type
  has_many :pokemon_moves
  has_many :pokemons, through: :pokemon_moves

  validates :name, presence: true, uniqueness: true
  validates :power, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :accuracy, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
end
