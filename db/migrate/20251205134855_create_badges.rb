class CreateBadges < ActiveRecord::Migration[7.1]
  def change
    create_table :badges do |t|
      t.string :name, null: false
      t.text :description
      t.string :icon
      t.string :rule_key, null: false

      t.timestamps
    end

    add_index :badges, :rule_key, unique: true
  end
end
