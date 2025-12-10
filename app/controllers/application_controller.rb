class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def after_sign_up_path_for(resource)
    dashboard_path
  end

  private

  def check_badges_and_notify
    return unless current_user

    newly_earned = BadgeAwarder.new(current_user).check_all!
    return if newly_earned.empty?

    session[:earned_badges] = newly_earned.map do |badge_info|
      {
        "name" => badge_info[:badge].name,
        "description" => badge_info[:badge].description,
        "rule_key" => badge_info[:badge].rule_key,
        "level" => badge_info[:level],
        "level_name" => badge_info[:level_name],
        "upgraded" => badge_info[:upgraded]
      }
    end
  end
end
