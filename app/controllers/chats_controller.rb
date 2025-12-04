class ChatsController < ApplicationController
before_action :set_chat, only: [:show]

  def index
    @chats = Chat.all.order(updated_at: :desc)
  end

  def show
    @message = Message.new
  end

  def new
    @chat = Chat.new()

    @recipe_requirements = {
      ingredients: nil,
      skill_level: 'Beginner',
      meal_type: 'Dinner',
      meal_prep_time: nil,
      restrictions: nil
    }
  end

  def create
    # Récupérer les paramètres autorisés (y compris le hash imbriqué)
    recipe_requirements = chat_params[:recipe_requirements]
    # Accéder aux ingrédients (vous pouvez les utiliser pour générer le premier message/prompt)
    @ingredients = recipe_requirements[:ingredients]
    @skill_level = recipe_requirements[:skill_level]
    @meal_type = recipe_requirements[:meal_type]
    @meal_prep_time = recipe_requirements[:meal_prep_time]
    @restrictions = recipe_requirements[:restrictions]

    # Créer le Chat

    @chat = Chat.new(user: current_user, title: recipe_requirements[:ingredients])

    # ... logique de création de message et LLM ici ...

    if @chat.save
      user_prompt = "My ingredients are: #{recipe_requirements[:ingredients]}, my skill level is: #{recipe_requirements[:skill_level]}, I have #{recipe_requirements[:meal_prep_time]} min to prepare it, my food restriction are: #{recipe_requirements[:restrictions]}"

      # 2. Enregistrer le message de l'utilisateur (pour l'historique)
      user_message = Message.create!(
        chat: @chat,
        role: "user",
        content: user_prompt,
      )

      @ruby_llm_chat = RubyLLM.chat
      build_conversation_history

      # 4. Appeler l'IA
      # Assurez-vous que RubyLLM est bien configuré (clé API et modèle)
      response = RubyLLM.chat.with_instructions(system_prompt).ask(user_message.content)

      # 5. Sauvegarder la réponse de l'assistant
      Message.create!(
        chat: @chat,
        role: "assistant",
        content: response.content,
        # message_type: "multichoice"
      )

      # 6. Rediriger (UNE SEULE FOIS)
      redirect_to chat_path(@chat)
    else
      # Gérer l'erreur
      render :new, status: :unprocessable_entity
    end

  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:id])
  end


  def chat_params
  # 1. Requérir la clé principale :chat
  params.require(:chat).permit(
    # 2. Permettre les autres attributs directs du Chat si besoin (ex: title)
    :title,

    # 3. Permettre le hash imbriqué :recipe_requirements
    #    et lister toutes ses sous-clés autorisées (Strong Parameters)
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
    Chat::SYSTEM_PROMPT + "  username:" + current_user.username
  end

  def build_conversation_history
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(message)
    end
  end

end
