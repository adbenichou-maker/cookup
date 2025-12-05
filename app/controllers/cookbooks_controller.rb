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
    if params[:rating].present?
      @saved_recipes = @saved_recipes
        .left_joins(:reviews)
        .group(:id)
        .having("ROUND(AVG(reviews.rate)) = ?", params[:rating].to_i)
    end
    # @steps = @recipe.steps
  end

end
