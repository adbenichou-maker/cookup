class UserSkillsController < ApplicationController
  before_action :authenticate_user!
  def create
    @skill = Skill.find(params[:skill_id])
    @user_skill = current_user.user_skills.new(skill: @skill)

    if @user_skill.save
      flash[:notice] = "Skill '#{@skill.title}' added to your learned skills!"
      redirect_to skills_path
    else
      flash[:alert] = @user_skill.errors.full_messages.to_sentence
      redirect_to skill_path(@skill)
    end
  end
end
