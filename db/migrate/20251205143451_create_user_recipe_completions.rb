class CreateUserRecipeCompletions < ActiveRecord::Migration[7.1]
  def change
    create_table :user_recipe_completions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
    add_index :user_recipe_completions, [:user_id, :recipe_id]
  end
end
