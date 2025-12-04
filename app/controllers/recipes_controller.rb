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
        .group(:id)
        .having("ROUND(AVG(reviews.rate)) = ?", params[:rating].to_i)
    end
    # @steps = @recipe.steps
  end

  def create
  end

  def congratulation
    @recipe = Recipe.find(params[:id])

    @old_level = current_user.level
    @old_xp_percent = current_user.progress_percentage

    xp_amount =
      case @recipe.recipe_level
      when "beginner" then 10
      when "intermediate" then 20
      when "expert" then 30
      end

    # Old behaviour: award XP when visiting this action
    current_user.add_xp(xp_amount)

    @new_xp_percent = current_user.progress_percentage
    @new_level = current_user.level

    @leveled_up = @new_level > @old_level
  end

end
