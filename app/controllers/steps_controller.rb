class StepsController < ApplicationController

  def index
    @recipe = Recipe.find(params[:recipe_id])
    @steps = Step.where(recipe: @recipe)
  end

end
