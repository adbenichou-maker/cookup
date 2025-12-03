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
      sql_query = "title ILIKE :query OR description ILIKE :query"
      @recipes = @recipes.where(sql_query, query: "%#{@query}%")
    end

    # Filter: difficulty level
    if @query.present?
      sql_query = "
        title ILIKE :query
        OR description ILIKE :query
        OR ingredients::text ILIKE :query
      "
      @recipes = @recipes.where(sql_query, query: "%#{@query}%")
    end

    # Filter: time
    if params[:time].present?
      @recipes = @recipes.where("cooking_time <= ?", params[:time])
    end
    # @steps = @recipe.steps
  end

  def create
  end

end
