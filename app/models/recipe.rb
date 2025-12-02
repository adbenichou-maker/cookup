class Recipe < ApplicationRecord
  enum :recipe_level, [:beginner, :intermediate, :expert ]
  belongs_to :message, optional: true
  belongs_to :user, optional: true
  has_many :steps, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :title,:content, presence: true
end
