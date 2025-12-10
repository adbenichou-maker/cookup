class UserSkillsController < ApplicationController
  before_action :authenticate_user!
  def create
    @skill = Skill.find(params[:skill_id])
    @user_skill = current_user.user_skills.new(skill: @skill)

    if @user_skill.save
      current_user.add_xp(30)
      check_badges_and_notify

      flash[:notice] = "Skill '#{@skill.title}' added to your learned skills!"

      redirect_to skill_path(
        @skill,
        recipe_id: params[:recipe_id],
        return_page: params[:return_page]
      )

    else
      flash[:alert] = @user_skill.errors.full_messages.to_sentence
      redirect_to skill_path(@skill)
    end
  end
end
