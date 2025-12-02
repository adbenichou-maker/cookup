class Step < ApplicationRecord
  belongs_to :recipe
  belongs_to :skill, optional: true

  validates :title, :content, presence: true
end
