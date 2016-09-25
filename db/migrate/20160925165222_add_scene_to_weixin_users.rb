class AddSceneToWeixinUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :weixin_users, :scene, :string
  end
end
