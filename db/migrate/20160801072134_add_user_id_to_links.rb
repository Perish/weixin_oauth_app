class AddUserIdToLinks < ActiveRecord::Migration[5.0]
  def change
    add_reference :links, :user, foreign_key: true
  end
end
