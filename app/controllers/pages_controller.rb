class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def dashboard
    @user = current_user
    @recipes = @user.recipes
    @saved_recipes = @user.favorites .includes(:recipe) .map(&:recipe) .sample(3)
  end
end
