class AddGenleToYoutubers < ActiveRecord::Migration[5.2]
  def change
    add_column :youtubers, :genle, :string
    add_column :youtubers, :number_of_registrant, :integer
  end
end
