class AddWeixinUserTokenIdToWeixinUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :weixin_users, :weixin_user_token, foreign_key: true
  end
end
