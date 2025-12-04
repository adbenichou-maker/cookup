class Recipe < ApplicationRecord
  enum :recipe_level, [:beginner, :intermediate, :expert ], _prefix: true
  belongs_to :message, optional: true
  belongs_to :user, optional: true
  belongs_to :user_recipes, optional: true
  has_many :steps, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :saved_by_users, through: :favorites, source: :user


  validates :title,:description, :ingredients, :recipe_level, presence: true
  accepts_nested_attributes_for :steps, allow_destroy: true


  def average_rating
    return 0 if reviews.empty?
    reviews.average(:rate).to_f.round(1)
  end

  include PgSearch::Model
  pg_search_scope :search_by_title_and_more,
    against: [ :title, :description, :ingredients ],
    using: {
      tsearch: { prefix: true }
    }
end
