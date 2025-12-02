class AddMessageToRecipe < ActiveRecord::Migration[7.1]
  def change
    add_reference :recipes, :message, null: true, foreign_key: true
  end
end
