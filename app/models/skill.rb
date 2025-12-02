class Skill < ApplicationRecord
  enum :skill_level, [ :beginner, :intermediate, :expert ]
end
