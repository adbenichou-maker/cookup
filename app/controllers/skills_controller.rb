class SkillsController < ApplicationController

  def index
  end

  def show
    @skill = Skill.find(params[:id])
  end

end
