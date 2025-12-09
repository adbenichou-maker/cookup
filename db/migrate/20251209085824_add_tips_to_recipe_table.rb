class AddTipsToRecipeTable < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :tips, :text, null: true
  end
end
