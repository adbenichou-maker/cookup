class CookbooksController < ApplicationController
  before_action :authenticate_user!

  def index
    @saved_recipes = current_user.saved_recipes
  end

  def search
    @query = params[:query]

    @saved_recipes = current_user.saved_recipes

    # Search text
    if @query.present?
      @saved_recipes = current_user.saved_recipes.search_by_title_and_more(@query)
    end

    # Filter: difficulty level
    if params[:level].present?
      @saved_recipes = @saved_recipes.where(recipe_level: params[:level])
    end

    # Filter by rating
    if params[:prep_time].present?
      prep = params[:prep_time].to_i
      @saved_recipes = @saved_recipes.where("meal_prep_time <= ?", prep) if prep < 120
    end
  end

end
