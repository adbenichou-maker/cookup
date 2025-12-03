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
      @recipes = Recipe.search_by_title_and_more(@query)
    end

    # Filter: difficulty level
    if params[:level].present?
      @recipes = @recipes.where(recipe_level: params[:level])
    end

    # Filter by rating
    if params[:rating].present?
      @recipes = @recipes
        .left_joins(:reviews)
        .group("recipes.id")
        .having("AVG(reviews.rate) >= ?", params[:rating])
    end

    # @steps = @recipe.steps
  end

  def create
  end

  def congratulation
    @recipe = Recipe.find(params[:id])
  end

end
