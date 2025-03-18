class StaticPagesController < ApplicationController
  def home

    @pokemon = Pokemon.all
  end
  def about
  end
end
