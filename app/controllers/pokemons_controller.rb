class PokemonsController < ApplicationController
  def index
    @pokemons = Pokemon.all.order(:id)
  end

  def show
    @pokemon = Pokemon.find(params[:id])
  end
end
