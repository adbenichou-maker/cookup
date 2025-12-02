class Step < ApplicationRecord
  belongs_to :recipe
  belongs_to :skill
end
