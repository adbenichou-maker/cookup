class AddLevelToRecipe < ActiveRecord::Migration[7.1]
  def change
      add_column :recipes, :recipe_level, :integer, default: 0
  end
end
