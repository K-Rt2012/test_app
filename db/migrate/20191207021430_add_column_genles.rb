class AddColumnGenles < ActiveRecord::Migration[5.2]
  def change
    add_column :genles, :group, :string
  end
end
