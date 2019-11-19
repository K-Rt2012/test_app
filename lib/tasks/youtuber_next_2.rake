namespace :youtuber_next_2 do
  desc "youtuber_next(webサイト)のスクレイピング"
  task :task_youtuber_next_2 => :environment do
    Encoding.default_external = 'utf-8'
    #Nokogiriライブラリの読み込み
    require 'nokogiri'
    # URLにアクセスするためのライブラリの読み込み
    require 'open-uri'
    #csvファイルを取り扱うためのライブラリ
    require 'csv'
    #active_supportのcore_ext/numeric/conversionsを読み込み
    require 'active_support/core_ext/numeric/conversions'
    #JavaScriptで生成されているものを解析できるジェムを読み込み
    require 'capybara/poltergeist'

    youtubers_data = Array.new
    youtuber_number = 1..4000
    charset = nil
    youtuber_number.each do |number|
      begin
        youtuber_html = open("https://youtubernext.jp/youtuber/yt_#{number}/") do |f|
          # 文字種別を取得
          charset = f.charset
          # htmlを読み込んで変数htmlに渡す
          f.read
        end
      rescue OpenURI::HTTPError => e
      end
      #htmlをパース(解析)してオブジェクトを生成
      page = Nokogiri::HTML.parse(youtuber_html,nil,charset)
      File.open("page.html", "w") do |f|
        f.puts(youtuber_html)
      end
      youtuber_data = Array.new
      #チャンネル名を抽出
      youtuber_name = page.xpath("//*[@class='youtuber_single_head']/div/h1").inner_text
      #チャンネル名が空なら処理を終了
      if youtuber_name != ""
        youtuber_name = youtuber_name.gsub(/\s/, "")
        p youtuber_name
        youtuber_data << youtuber_name
        #登録者数を抽出
        subscriber = page.xpath("//*[@class='youtuber_single_head']/div/p[1]").inner_text
        subscriber = subscriber.gsub(/チャンネル登録者数|\n|\s/, "")
        p subscriber
        youtuber_data << subscriber
        #channel_idを抽出
        channel_id = page.xpath("//*[@class='youtuber_single_head']/div/p[2]").inner_text
        channel_id.match(/https:\/\/www.youtube.com\/channel\/((\w|-|_)*)/) do |id|
          channel_id = id[1]
        end
        p channel_id
        youtuber_data << channel_id
        #ジャンルを抽出
        #genres = Array.new
        page.xpath("/html/body/main/div/section[1]/div[3]/div/div[3]/a").each do |genre|
          #genres << genre.inner_text
          youtuber_data << genre.inner_text
        end
        #p genres
        youtubers_data << youtuber_data
      else
        p "処理を終了します"
        break
      end
    end
    #csvファイルを開き、UTF－8で変数youtubers_dataの値を書き込み
    csv_format = CSV.open(Rails.root.join('config', 'youtuber_list', 'youtuber_next_data.csv'), "w:UTF-8") do |test|
      youtubers_data.each do |data|
        test << data
        puts csv_format
      end
    end
  end
end
