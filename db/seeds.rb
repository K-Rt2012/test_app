# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'
require 'httpclient'

  # p VideoCategory.create(category: 1, name: "映画とアニメ")
  # p VideoCategory.create(category: 2, name: "自動車と乗り物")
  # p VideoCategory.create(category: 10, name: "音楽")
  # p VideoCategory.create(category: 15, name: "ペットと動物")
  # p VideoCategory.create(category: 17, name: "スポーツ")
  # p VideoCategory.create(category: 19, name: "旅行とイベント")
  # p VideoCategory.create(category: 20, name: "ゲーム")
  # p VideoCategory.create(category: 22, name: "ブログ")
  # p VideoCategory.create(category: 23, name: "コメディー")
  # p VideoCategory.create(category: 24, name: "エンターテイメント")
  # p VideoCategory.create(category: 25, name: "ニュースと政治")
  # p VideoCategory.create(category: 26, name: "ハウツーとスタイル")
  # p VideoCategory.create(category: 27, name: "教育")
  # p VideoCategory.create(category: 28, name: "科学と技術")
CSV.foreach(Rails.root.join('config', 'youtuber_list', 'video_data.csv')) do |video_data|
  CSV.foreach(Rails.root.join('config', 'youtuber_list', 'youtuber_next_data.csv')).with_index(1) do |youtuber_data,index|
    next if index > 100
    p index
    p youtuber_data[2]
    p video_data[0]
    #youtuberstableに登録されているデータを弾く処理
    unless Youtuber.exists?(channel_id: youtuber_data[2])
      #配列の要素を数える
      number = youtuber_data.count
      p number
      a = youtuber_data[3]
      genles = Array.new
      if youtuber_number >= 4
        number = 4..number
        number.each do |g|
          p youtuber_data[g]
          genles << youtuber_data[g]
        end
        a = genles.join(", ")
      end
      p a
      youtuber_data[1].gsub!(/,|人/, "")
      youtuber_data[1].to_i
      p youtuber_data[1]
      youtuber = Youtuber.create(name: youtuber_data[0], number_of_registrant: youtuber_data[1], channel_id: youtuber_data[2], genle: a)
      category = VideoCategory.find_by(category: video_data[2])
      Video.create(video_id: video_data[0], video_title: video_data[1], youtuber_id: youtuber.id, video_category_id: category.category)
    end
  end
end