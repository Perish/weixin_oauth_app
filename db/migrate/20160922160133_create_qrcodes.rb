class CreateQrcodes < ActiveRecord::Migration[5.0]
  def change
    create_table :qrcodes do |t|
      t.string :ticket
      t.string :url
      t.string :scene
      t.integer :weixin_id

      t.timestamps
    end

    add_index :qrcodes, :weixin_id
    add_index :qrcodes, :scene
  end
end
