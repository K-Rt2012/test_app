class AddColumnGenle < ActiveRecord::Migration[5.2]
  def change
    add_column :genles, :genle_category_id, :integer
  end
end
