namespace :task_test do
  desc "task_sample_use_model"
  task :task_test => :environment do
    require 'csv'
    Encoding.default_external = 'utf-8'
    #Nokogiriライブラリの読み込み
    require 'nokogiri'
    # URLにアクセスするためのライブラリの読み込み
    require 'open-uri'
    #csvファイルを取り扱うためのライブラリ
    require 'csv'
    #active_supportのcore_ext/numeric/conversionsを読み込み
    require 'active_support/core_ext/numeric/conversions'

    CSV.foreach(Rails.root.join('config','youtuber_list','youtuber_next_data.csv')).with_index(1) do |data,index|
      next if index > 180
      unless Video.exists?(youtuber_id: index)
        p data[2]
        p data[0]
        #youtuberstableに登録されているデータを弾く処理
        if data[2]
          api_id = "https://www.googleapis.com/youtube/v3/search?part=id,snippet&channelId=#{data[2]}&key=AIzaSyBd1wcxiyGzgosb5Renoi4eH3hWph7hulY"
          client = HTTPClient.new()
          response_playlist = client.get(api_id)
          response_str = response_playlist.body
          response_hash = JSON.parse(response_str)
          #多次元ハッシュ取り出し方、配列"items"の0番目のインデックスを指定して取り出し
          video_id = response_hash['items'][0]['id']['videoId']
          p video_id
          # 引数に指定した変数が存在し、その値が空や0でなければFALSEを返し、それ以外の場合はTRUEを返します
          if video_id.empty?
            p "値が空です"
            video_id = "idが存在しません"
            video_title = "titleが存在しません"
            category_id = "categoryが存在しません"
            videos_data = [video_id, video_title, category_id, data[2]]
            CSV.open(Rails.root.join('config', 'youtuber_list', 'video_data.csv'), "a:UTF-8") do |csv|
              csv << videos_data
            end
          else
            video_title = response_hash["items"][0]["snippet"]["title"]
            p video_title
            api_category_id = "https://www.googleapis.com/youtube/v3/videos?part=id,snippet&id=#{video_id}&key=AIzaSyBd1wcxiyGzgosb5Renoi4eH3hWph7hulY"
            response_category = client.get(api_category_id)
            response_category_str = response_category.body
            response_category_hash = JSON.parse(response_category_str)
            #多次元ハッシュ取り出し方、配列"items"の0番目のインデックスを指定して取り出し
            category_id = response_category_hash["items"][0]["snippet"]["categoryId"]
            p category_id
            videos_data = [video_id, video_title, category_id, data[2]]
            CSV.open(Rails.root.join('config', 'youtuber_list', 'video_data.csv'), "a:UTF-8") do |csv|
              csv << videos_data
            end
          end
        end
      end
    end
  end
end
