class UserRecipeCompletion < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  validates :user, presence: true
  validates :recipe, presence: true

  XP_REWARD = {
    0 => 20,
    1 => 40,
    2 => 60
  }.freeze

  after_create :give_xp_and_check_badges

  private

  def give_xp_and_check_badges
    xp = XP_REWARD[recipe.recipe_level.to_i] || 20
    user.add_xp(xp)
    BadgeAwarder.new(user).check_all!
  end
end
