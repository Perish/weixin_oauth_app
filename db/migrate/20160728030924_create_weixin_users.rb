class CreateWeixinUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :weixin_users do |t|
      t.string :openid
      t.string :nickname
      t.integer :sex
      t.string :province
      t.string :city
      t.string :country
      t.string :headimgurl
      t.text :privilege
      t.string :unionid

      t.timestamps
    end
  end
end
