class CreateRanks < ActiveRecord::Migration[5.2]
  def change
    create_table :ranks do |t|
      t.string :name
      t.string :channel_id
      t.string :number_of_registrant

      t.timestamps
    end
  end
end
