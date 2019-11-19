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

CSV.foreach(Rails.root.join('config', 'youtuber_list', 'youtuber_channels_data.csv')).with_index(1) do |data,index|
  next if index > 25
  p index
  #youtuberstableに登録されているデータを弾く処理
  p data[1]
  p data[0]
  unless Youtuber.exists?(channel_id: data[1])
    youtuber = Youtuber.create(name: data[0], channel_id: data[1])
    api_id = "https://www.googleapis.com/youtube/v3/search?part=id,snippet&channelId=#{youtuber.channel_id}&key=AIzaSyBd1wcxiyGzgosb5Renoi4eH3hWph7hulY"
    client = HTTPClient.new()
    response_playlist = client.get(api_id)
    response_str = response_playlist.body
    response_hash = JSON.parse(response_str)
    #多次元ハッシュ取り出し方、配列"items"の0番目のインデックスを指定して取り出し
    video_id = response_hash['items'][0]['id']['videoId']
    p video_id
    video_title = response_hash["items"][0]["snippet"]["title"]
    p video_title
    api_category_id = "https://www.googleapis.com/youtube/v3/videos?part=id,snippet&id=#{video_id}&key=AIzaSyBd1wcxiyGzgosb5Renoi4eH3hWph7hulY"
    response_category = client.get(api_category_id)
    response_category_str = response_category.body
    response_category_hash = JSON.parse(response_category_str)
    #多次元ハッシュ取り出し方、配列"items"の0番目のインデックスを指定して取り出し
    category_id = response_category_hash["items"][0]["snippet"]["categoryId"]
    p category_id
    category = VideoCategory.find_by(category: category_id)
    Video.create(video_id: video_id, video_title: video_title, youtuber_id: youtuber.id, video_category_id: category.category)
  end
end
