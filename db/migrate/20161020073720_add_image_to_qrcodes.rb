class AddImageToQrcodes < ActiveRecord::Migration[5.0]
  def change
    add_column :qrcodes, :image, :string
  end
end
