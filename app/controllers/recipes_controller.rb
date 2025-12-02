class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def search
    @query = params[:query]

    @recipes = Recipe.all

    # Search text
    if @query.present?
      @recipes = @recipes.where("title ILIKE ?", "%#{@query}%")
    end

    # Filter: difficulty level
    if params[:level].present?
      @recipes = @recipes.where(recipe_level: params[:level])
    end

    # Filter: time
    if params[:time].present?
      @recipes = @recipes.where("cooking_time <= ?", params[:time])
    end
  end

  def create
  end

end
