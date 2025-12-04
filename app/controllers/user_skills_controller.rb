class UserSkillsController < ApplicationController

  def create

    @user_skill = UserSkill.new
    @user_skill.safe

    if @user_skill.save
      current_user.add_xp(30)
    end

  end

end
