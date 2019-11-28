require 'csv'
require 'httpclient'
Encoding.default_external = 'utf-8'

videos_data = Array.new
CSV.foreach('youtuber_next_data.csv').with_index(1) do |data,index|
  #next if index > 100
  p index
  p data[2]
  p data[0]
  #youtuberstableに登録されているデータを弾く処理
  if data[2]
    api_id = "https://www.googleapis.com/youtube/v3/search?part=id,snippet&channelId=#{data[2]}&key=AIzaSyBd1wcxiyGzgosb5Renoi4eH3hWph7hulY"
    client = HTTPClient.new()
    response_playlist = client.get(api_id)
    response_str = response_playlist.body
    p response_str
    response_hash = JSON.parse(response_str)
    p response_hash
    #多次元ハッシュ取り出し方、配列"items"の0番目のインデックスを指定して取り出し
    video_id = response_hash['items'][0]['id']['videoId']
    if video_id != ""
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
      videos_data << [video_id, video_title, category_id, data[2]]
    end
  end
end
csv_format = CSV.open(Rails.root.join('config', 'youtuber_list', 'video_data.csv'), "w:UTF-8") do |test|
  videos_data.each do |data|
    test << data
  end
end
