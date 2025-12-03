class Skill < ApplicationRecord
  enum :skill_level, [ :beginner, :intermediate, :expert ], _prefix: true
  has_one :step
  validates :title, :description, :video, :skill_level, presence: true
end
