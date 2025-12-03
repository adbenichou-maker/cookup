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
    @message = Message.find(params[:message_id])

    chat = RubyLLM.chat
    response = chat.with_schema(Recipe::RecipeSchema).ask(@message.content)

    # The response is automatically parsed from JSON

    @recipe = Recipe.new(response.content)
    raise

    @recipe.message = @message

    @recipe.content = @message.content

    @recipe.save

    if @recipe.save
      chat = @message.chat
      redirect_to chat_path(chat), notice: "Saved Recipe!"
    else
      @message = @recipe.message
        render :new, status: :unprocessable_entity
    end
  end

  # def destroy
  #   @recipe = Recipe.find(params[:id])
  #   @recipe.destroy
  #   redirect_to recipes_path, notice: "#{@recipe.title} was successfully deleted."
  # end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :description, :ingredients, :recipe_level, :message_id, :user_id)
    # Ajoutez tous les attributs de Recipe qui peuvent être modifiés par le formulaire
  end

end
