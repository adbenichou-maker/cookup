class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def dashboard
    @user = current_user
    @recipes = @user.recipes
    @saved_recipes = @user.favorites .includes(:recipe) .map(&:recipe) .sample(3)
    @level = current_user.level
    @xp = current_user.xp
    @progress = current_user.progress_percentage
  end
end
