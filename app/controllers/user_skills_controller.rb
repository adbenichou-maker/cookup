class UserSkillsController < ApplicationController

  def create

    @user_skill = UserSkill.new
    @user_skill.safe
  end

end
