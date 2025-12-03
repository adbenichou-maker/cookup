class CookbooksController < ApplicationController
  before_action :authenticate_user!

  def index
    @recipes = current_user.saved_recipes
  end
end
