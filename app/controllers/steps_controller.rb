class StepsController < ApplicationController

  def index
    @recipe = Recipe.find(params[:id])
    @steps = Step.where(recipe: @recipe)
  end

end
