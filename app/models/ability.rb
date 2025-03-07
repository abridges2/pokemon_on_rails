class Ability < ApplicationRecord
  has_many :pokemon_abilities
  has_many :pokemon, through: :pokemon_abilities

  validates :name, :description, presence: true, uniqueness: true
  validates :description, presence: true
end
