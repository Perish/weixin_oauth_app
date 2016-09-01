class AddLinkTypeToLinks < ActiveRecord::Migration[5.0]
  def change
    add_column :links, :link_type, :integer, default: 0
  end
end
