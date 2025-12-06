class Badge < ApplicationRecord
  has_many :user_badges, dependent: :destroy
  has_many :users, through: :user_badges

  validates :name, :rule_key, presence: true
  validates :rule_key, uniqueness: true

  # Award this badge to a user (idempotent)
  def award_to(user)
    return unless user
    ub = user_badges.find_or_initialize_by(user: user)
    if ub.new_record?
      ub.awarded_at = Time.current
      ub.save!
      return :awarded
    end
    :already
  end
end
