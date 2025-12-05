class AddLevelToUserBadges < ActiveRecord::Migration[7.1]
  def change
    add_column :user_badges, :level, :integer
  end
end
