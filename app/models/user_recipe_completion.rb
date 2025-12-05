class UserRecipeCompletion < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  # optional: validations
  validates :user, presence: true
  validates :recipe, presence: true
end
