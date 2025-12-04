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
    recipe_prompt = <<~PROMPT
      You are to output ONLY a JSON object. No explanations. No surrounding text.
      Here is my recipe data: #{@message.content}

      Produce a JSON object that follows EXACTLY this structure:
      {
        "title": string,
        "description": string,
        "ingredients": {
          "<ingredient_name>": "<quantity_as_string>"
        },
        "recipe_level": integer (0 for beginner, 1 for intermediate, 2 for expert),
        "steps_attributes": [
          {
            "title": string,
            "content": string
          }
        ]
      }

      Rules:
      - Include everything in a overall JSON object.
      - Ensure the JSON is valid.
      - Use the exact keys as specified.
      - Output ONLY valid JSON.
      - Do NOT add comments, descriptions, markdown, or extra keys.
      - Do NOT wrap the JSON in code fences.
      - Do NOT explain your answer.
      - Ensure all values match the recipe data provided.
    PROMPT

    response = chat.ask(recipe_prompt)
    # The response is automatically parsed from JSON
    recipe_data = JSON.parse(response.content)
    @recipe = Recipe.new(recipe_data)
    # The response is automatically parsed from JSON
    @recipe.user_id = current_user.id
    @recipe.message_id = @message.id

    # @recipe.save

    # recipe_data["steps"].each do |step_data|
    #   step = Step.new(
    #     title: step_data["title"],
    #     content: step_data["content"],
    #     recipe: @recipe
    #   )
    #   step.save
    # end

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
