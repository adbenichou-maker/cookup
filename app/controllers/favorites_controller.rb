class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @recipe = Recipe.find(params[:recipe_id])
    @favorite = Favorite.new(user: current_user, recipe: @recipe)

    if @favorite.save
      BadgeAwarder.new(current_user).check_all!
      redirect_back fallback_location: recipe_path(@recipe), notice: "Recipe saved!"
    else
      redirect_back fallback_location: recipe_path(@recipe), alert: "Already saved."
    end
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
    redirect_back fallback_location: cookbook_path, notice: "Recipe removed."
  end
end
