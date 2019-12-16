class CreateGenleCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :genle_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
