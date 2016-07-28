class AddLanguageToWeixinUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :weixin_users, :language, :string
  end
end
