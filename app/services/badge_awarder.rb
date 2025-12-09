class BadgeAwarder
  LEVELS = {
    1 => 5,   # Bronze
    2 => 10,  # Silver
    3 => 15,  # Gold
    4 => 20   # Platinum
  }.freeze

  LEVEL_NAMES = {
    1 => "Bronze",
    2 => "Silver",
    3 => "Gold",
    4 => "Platinum"
  }.freeze

  RECIPE_LEVELS = {
    beginner: 0,
    intermediate: 1,
    expert: 2
  }.freeze

  def initialize(user)
    @user = user
    @newly_earned = []
  end

  # Returns array of newly earned badges with their level info
  def check_all!
    @newly_earned = []
    check_recipe_level_badges
    check_saved_recipes_badges
    check_skills_badges
    check_streak_badges
    @newly_earned
  end

  private

  def award_progress_badge(base_key, count)
    badge = Badge.find_by(rule_key: base_key)
    return unless badge

    user_badge = @user.user_badges.find_or_initialize_by(badge: badge)

    new_level =
      LEVELS.keys.reverse.find { |level| count >= LEVELS[level] } || 0

    old_level = user_badge.level || 0
    if old_level < new_level
      user_badge.level = new_level
      user_badge.awarded_at = Time.current
      user_badge.save!

      @newly_earned << {
        badge: badge,
        level: new_level,
        level_name: LEVEL_NAMES[new_level],
        upgraded: old_level > 0
      }
    end
  end

  def check_recipe_level_badges
    RECIPE_LEVELS.each do |name, value|
      count = UserRecipeCompletion.joins(:recipe)
              .where(user: @user, recipes: { recipe_level: value })
              .distinct.count

      award_progress_badge("recipe_#{name}", count)
    end
  end

  def check_saved_recipes_badges
    count = @user.saved_recipes.distinct.count
    award_progress_badge("saved_recipes", count)
  end

  def check_skills_badges
    count = @user.user_skills.distinct.count
    award_progress_badge("skills_completed", count)
  end

  def check_streak_badges
    streak = consecutive_completion_days
    award_progress_badge("streak", streak)
  end

  def consecutive_completion_days
    days = 0
    date = Date.current

    loop do
      completed = UserRecipeCompletion
                    .where(user: @user)
                    .where(created_at: date.beginning_of_day..date.end_of_day)
                    .exists?

      break unless completed

      days += 1
      date -= 1.day
    end

    days
  end
end
