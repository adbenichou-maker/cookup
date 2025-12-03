class SkillsController < ApplicationController

  def index
    # @skills = Skill.where(skill_level = params[:skill_level])

    if Skill.skill_levels.keys.include?(params[:level])
        @skills = Skill.where(skill_level: params[:level])
        @selected_level = params[:level].humanize
    else
      @skill_levels = Skill.skill_levels.keys
    end
  end

  def show
    @skill = Skill.find(params[:id])

    if params[:recipe_id].present?
      @return_recipe = Recipe.find_by(id: params[:recipe_id])
    end
  end

end
