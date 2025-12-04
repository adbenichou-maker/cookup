class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :user_skills, dependent: :destroy
  has_many :chats
  has_many :messages, through: :chats
  has_many :recipes
  has_many :favorites, dependent: :destroy
  has_many :saved_recipes, through: :favorites, source: :recipe


  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true
  def add_xp(amount)
    self.xp += amount

    while self.xp >= 100
      self.xp -= 100
      self.level += 1
    end

    save!
  end

  def progress_percentage
    xp
  end

end
