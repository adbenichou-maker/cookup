class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.string :title
      t.text :comment
      t.integer :rate
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
