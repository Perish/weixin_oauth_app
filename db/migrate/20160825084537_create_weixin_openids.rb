class CreateWeixinOpenids < ActiveRecord::Migration[5.0]
  def change
    create_table :weixin_openids do |t|
      t.references :weixin_user, foreign_key: true
      t.integer :apid
      t.string :openid

      t.timestamps
    end
  end
end
