class ChatsController < ApplicationController
  before_action :set_chat, only: [:show]

  def index
    @chats = Chat.all.order(updated_at: :desc)
  end

  def show
    @message = Message.new
  end

  def new
    @chat = Chat.new

    @recipe_requirements = {
      ingredients: nil,
      skill_level: 'Beginner',
      meal_type: 'Dinner',
      meal_prep_time: nil,
      restrictions: nil
    }
  end

  def create
    # Safely extract nested hash (avoid nil)
    recipe_requirements = chat_params[:recipe_requirements] || {}

    # Read values from nested hash
    @ingredients  = recipe_requirements[:ingredients]
    @skill_level  = recipe_requirements[:skill_level]
    @meal_type    = recipe_requirements[:meal_type]
    @restrictions = recipe_requirements[:restrictions]

    # Parse prep time from slider: 120 = "no limit"
    prep = recipe_requirements[:meal_prep_time].to_i
    @meal_prep_time = (prep == 120 ? nil : prep)

    # Build a sensible title (fallback if ingredients missing)
    title = @ingredients.present? ? @ingredients : "New Chat"
    @chat = Chat.new(user: current_user, title: title)

    if @chat.save
      # Build text for the prompt with a friendly phrasing
      prep_text = @meal_prep_time.nil? ? "no time limit" : "#{@meal_prep_time} minutes"
      user_prompt = "My ingredients are: #{@ingredients}, my skill level is: #{@skill_level}, I have #{prep_text} to prepare it, my food restriction are: #{@restrictions}"

      # Save the user message for history
      user_message = Message.create!(
        chat: @chat,
        role: "user",
        content: user_prompt
      )

      # Prepare and call the LLM
      @ruby_llm_chat = RubyLLM.chat
      build_conversation_history

      # Ensure RubyLLM configured — then ask
      response = RubyLLM.chat.with_instructions(system_prompt).ask(user_message.content)

      # Save assistant response
      Message.create!(
        chat: @chat,
        role: "assistant",
        content: response.content
      )

      # Redirect to the chat view
      redirect_to chat_path(@chat)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:id])
  end

  def chat_params
    params.require(:chat).permit(
      :title,
      recipe_requirements: [
        :cuisine,
        :ingredients,
        :skill_level,
        :meal_type,
        :meal_prep_time,
        :restrictions
      ]
    )
  end

  def system_prompt
    Chat::SYSTEM_PROMPT + " username:" + current_user.username.to_s
  end

  def build_conversation_history
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(message)
    end
  end
end
