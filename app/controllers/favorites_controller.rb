class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @recipe = Recipe.find(params[:recipe_id])
    @favorite = current_user.favorites.build(recipe: @recipe)

    respond_to do |format|
      if @favorite.save
        format.html { redirect_back fallback_location: cookbook_path, notice: "Saved to cookbook" }
        format.turbo_stream
      else
        format.html { redirect_back fallback_location: cookbook_path, alert: "Could not save" }
        format.turbo_stream { render turbo_stream: turbo_stream.replace(dom_id_for(@recipe, "favorite_button"), partial: "favorites/favorite_button", locals: { recipe: @recipe }) }
      end
    end
  end

  def destroy
    @favorite = current_user.favorites.find(params[:id])
    @recipe   = @favorite.recipe
    @favorite.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: cookbook_path }
      format.turbo_stream
    end
  end

end
