class CreateSteps < ActiveRecord::Migration[7.1]
  def change
    create_table :steps do |t|
      t.string :title
      t.text :content
      t.references :recipe, null: false, foreign_key: true
      t.references :skill, null: true, foreign_key: true

      t.timestamps
    end
  end
end
