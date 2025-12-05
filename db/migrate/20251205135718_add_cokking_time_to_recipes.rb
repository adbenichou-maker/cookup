class AddCokkingTimeToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :meal_prep_time, :integer
  end
end
