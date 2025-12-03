class SkillsController < ApplicationController

  def index
    @skills = Skill.where(@skill.skill_level = params[:skill_level])
  end

  def show
    @skill = Skill.find(params[:id])
  end

end
