class AddSkillLevelToSkill < ActiveRecord::Migration[7.1]
  def change
    add_column :skills, :skill_level, :integer, default: 0
  end
end
