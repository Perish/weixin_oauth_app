class AddAidToWeixinUserTokens < ActiveRecord::Migration[5.0]
  def change
    add_column :weixin_user_tokens, :aid, :integer, default: 1
  end
end
