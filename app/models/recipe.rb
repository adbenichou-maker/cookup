class Recipe < ApplicationRecord
  enum :recipe_level, [:beginner, :intermediate, :expert ]
end
