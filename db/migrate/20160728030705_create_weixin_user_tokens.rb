class CreateWeixinUserTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :weixin_user_tokens do |t|
      t.text :access_token
      t.integer :expires_in
      t.text :refresh_token
      t.string :openid
      t.string :scope

      t.timestamps
    end
  end
end
