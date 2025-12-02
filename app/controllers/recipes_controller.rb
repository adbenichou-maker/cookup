class RecipesController < ApplicationController

  def index
  end

  def show
    @recipe = Recipe.find(params[:id])
    @steps = @recipe.steps
  end

  def create
  end

end
