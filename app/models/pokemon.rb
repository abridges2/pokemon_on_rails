class Pokemon < ApplicationRecord
  has_many :pokemon_types
  has_many :types, through: :pokemon_types

  has_many :pokemon_abilities
  has_many :abilities, through: :pokemon_abilities

  has_many :pokemon_moves
  has_many :moves, through: :pokemon_moves

  validates :name, :height, :weight, :base_experience, :species, :sprite_url,  presence: true

  validates :name, uniqueness: true
  validates :sprite_url, uniqueness: true
end
