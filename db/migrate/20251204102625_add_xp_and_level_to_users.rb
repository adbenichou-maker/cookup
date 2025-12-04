class AddXpAndLevelToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :xp, :integer, default: 0
    add_column :users, :level, :integer, default: 1
  end
end
