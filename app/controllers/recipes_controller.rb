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

    # Filter: prep time
    if params[:prep_time].present?
      prep = params[:prep_time].to_i

      # Only filter if user chose < 120 (120 means "unlimited")
      if prep < 120
        @recipes = @recipes.where("meal_prep_time <= ?", prep)
      end
    end
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
        "meal_prep_time": integer (in minutes),
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
      favorites = Favorite.new(user: current_user, recipe: @recipe)
      favorites.save
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


  def congratulation
    @recipe = Recipe.find(params[:id])

    # Save old values BEFORE XP happens
    @old_level = current_user.level
    @old_xp_percent = current_user.progress_percentage

    if user_signed_in?
      recent_window_seconds = 30
      recent_exist = UserRecipeCompletion.where(user: current_user, recipe: @recipe)
                                        .where("created_at >= ?", recent_window_seconds.seconds.ago)
                                        .exists?

      unless recent_exist
        UserRecipeCompletion.create!(user: current_user, recipe: @recipe)
      end
    end

    # Load updated values
    @new_xp_percent = current_user.progress_percentage
    @new_level = current_user.level

    @leveled_up = @new_level > @old_level
  end



  private

  def recipe_params
    params.require(:recipe).permit(:title, :description, :ingredients, :recipe_level, :message_id, :user_id)
    # Ajoutez tous les attributs de Recipe qui peuvent être modifiés par le formulaire
  end

end
