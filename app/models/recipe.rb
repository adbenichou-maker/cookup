class Recipe < ApplicationRecord
  enum :recipe_level, [:beginner, :intermediate, :expert ]
  belongs_to :message, optional: true
  belongs_to :user, optional: true
  belongs_to :user_recipes, optional: true
  has_many :steps, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :title,:description, :ingredients, :recipe_level, presence: true
end
