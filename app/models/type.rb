class Type < ApplicationRecord
  has_many :pokemon_types
  has_many :pokemon, through: :pokemon_types

  validates :name, presence: true, uniqueness: true
end
