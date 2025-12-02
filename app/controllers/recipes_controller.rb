class RecipesController < ApplicationController

  def show
    @recipe = Recipe.find(params[:id])
    @steps = @recipe.steps
  end
end
