# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'net/http'
require 'json'

ActiveRecord::Base.connection.execute("PRAGMA foreign_keys = OFF;")

Pokemon.destroy_all
Type.destroy_all
Ability.destroy_all
Move.destroy_all
PokemonType.destroy_all
PokemonAbility.destroy_all
PokemonMove.destroy_all

ActiveRecord::Base.connection.execute("PRAGMA foreign_keys = ON;")
puts "Database has been cleared."

# Pokemon.
(1..151).each do |id|
  url = URI("https://pokeapi.co/api/v2/pokemon/#{id}")
  response = Net::HTTP.get(url)
  pokemon_data = JSON.parse(response)

  # Create a pokemon
  pokemon = Pokemon.create!(
    name: pokemon_data["name"],
    height: pokemon_data["height"],
    weight: pokemon_data["weight"],
    base_experience: pokemon_data["base_experience"],
    species: pokemon_data["species"],
    sprite_url: pokemon_data["sprites"]["front_default"]
  )

  # Give the pokemon their corresponding types
  pokemon_data["types"].each do |type_info|
    type_name = type_info["type"]["name"]
    type = Type.find_or_create_by!(name: type_name)

    PokemonType.create!(pokemon: pokemon, type: type, slot: type_info["slot"])
  end

  puts "Created #{pokemon.name} with types assigned"
end

puts "Original 151 pokemon have been created with their corresponding types."

# Types
puts "Giving the Pokemon types"
Pokemon


# Abilities.
puts "Giving Pokemon abilities"
Pokemon.all.each do |pokemon|
  url = URI("https://pokeapi.co/api/v2/pokemon/#{pokemon.name.downcase}")
  response = Net::HTTP.get(url)
  data = JSON.parse(response)

  # Creating all of the abilities.
  data["abilities"].each do |ability_info|
    ability_name = ability_info["ability"]["name"]
    ability_url = ability_info["ability"]["url"] # Embedded link to ability endpoint to get more information.

    ability_response = Net::HTTP.get(URI(ability_url))
    ability_data = JSON.parse(ability_response)

    # Getting list of effect entries containing the descriptions of abilities in multiple languages.
    effect_entries = ability_data["effect_entries"]

    # Getting list of flavor text entries as some effect entries do not contain descriptions for abilities.
    flavor_text_entries = ability_data["flavor_text_entries"]

    # Setting a default value for the ability description to aid checking if effect entries array returned no descriptions for abilities.
    ability_description = "No description found."

    # Looping through effect entries for an english description of the ability.
    effect_entries.each do |entry|
      if entry["language"]["name"] == "en" && entry["effect"] != ""
        ability_description = entry["effect"]
        break
      end
    end

    # If no english effect description gets found then we must check in flavor_text_entries for a description.
    if ability_description == "No description found."
      flavor_text_entries.each do |flavor_entry|
        if flavor_entry["language"]["name"] == "en" && flavor_entry["flavor_text"] != ""
          ability_description = flavor_entry["flavor_text"]
          break
        end
      end
    end

    # Create the ability
    ability = Ability.find_or_create_by!(name: ability_name, description: ability_description)

    # Give the pokemon the ability.
    PokemonAbility.create!(pokemon: pokemon, ability: ability, is_hidden: ability_info["is_hidden"])
  end

puts "#{pokemon.name} abilities assigned"
end

puts "All abilities have been assigned successfully"

# Moves
puts "Creating and assigning pokemon moves"
Pokemon.all.each do |pokemon|
  url = URI("https://pokeapi.co/api/v2/pokemon/#{pokemon.name.downcase}")
  response = Net::HTTP.get(url)
  data = JSON.parse(response)

  # Each pokemon will get 4 moves that they learn.
  data["moves"].first(5).each do |move_info|
    move_name = move_info["move"]["name"]
    move_url = move_info["move"]["url"]

    move_response = Net::HTTP.get(URI(move_url))
    move_data = JSON.parse(move_response)

    move_power = move_data["power"]
    move_accuracy = move_data["accuracy"]
    move_type = move_data["type"]["name"]

    # Ensuring the type exists in the database before creating a move under it.
    move_type_record = Type.find_or_create_by!(name: move_type)

    # Creating the move
    move = Move.find_or_create_by!(
      name: move_name,
      accuracy: move_accuracy,
      power: move_power,
      type: move_type_record
    )

    # Getting the level the pokemon will learn the move at
    level_learned = nil
    move_info["version_group_details"].each do |detail|
      if detail["move_learn_method"]["name"] == "level-up"
        level_learned = detail["level_learned_at"]
        break
      end
    end

    # Give the move to the pokemon only if it is learned by levelling up.
    if level_learned
      PokemonMove.create!(pokemon: pokemon, move: move, level_learned: level_learned)
    end
  end

  puts "#{pokemon.name} 4 moves assigned to #{pokemon.name}."
end

puts "Done assigning moves to Pokemon."
