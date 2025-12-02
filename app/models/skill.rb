class Skill < ApplicationRecord
  enum :skill_level, [ :beginner, :intermediate, :expert ]
  has_one :step
  validates :title, :description, :video, :skill_level, presence: true
end
