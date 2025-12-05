class AddUserReferenceToReviews < ActiveRecord::Migration[7.1]
  def change
    add_reference :reviews, :user, foreign_key: true, null: true
  end
end
