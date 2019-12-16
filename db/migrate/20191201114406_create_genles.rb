class CreateGenles < ActiveRecord::Migration[5.2]
  def change
    create_table :genles do |t|
      t.string :name

      t.timestamps
    end
    #belongs_to :モデル名 N対Nの関係を紐づける
    create_table :genles_youtubers do |t|
      t.belongs_to :genle
      t.belongs_to :youtuber
    end
  end
end
