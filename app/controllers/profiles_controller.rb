class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @badges = Badge.all.order(:rule_key)
    @user_badge_ids = @user.badges.pluck(:id)
  end
end
