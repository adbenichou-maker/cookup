class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :user_skills, dependent: :destroy
  has_many :chats
  has_many :messages, through: :chats
  has_many :recipes
  has_many :favorites, dependent: :destroy
  has_many :saved_recipes, through: :favorites, source: :recipe
  has_many :reviews, dependent: :destroy



  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true

  def xp_required_for_current_level
    (100 * (1.15 ** (level - 1))).round
  end

  # Add XP and handle leveling up
  def add_xp(amount)
    self.xp ||= 0
    self.level ||= 1

    self.xp += amount

    required = xp_required_for_current_level

    while xp >= required
      self.xp -= required
      self.level += 1
      required = xp_required_for_current_level
    end

    save!
  end

  # Progress bar percentage
  def progress_percentage
    required = xp_required_for_current_level
    ((xp.to_f / required) * 100).clamp(0, 100).round
  end

end
