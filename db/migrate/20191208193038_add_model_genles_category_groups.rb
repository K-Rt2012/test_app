class AddModelGenlesCategoryGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :genles_categorys_groups, id: false do |t|
      t.belongs_to :genle
      t.belongs_to :genle_category
    end
  end
end
