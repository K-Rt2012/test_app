namespace :task_sample do
  desc "task_sample_use_model"
  task :task_model => :environment do
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
    number_of_registrants = Array.new
    #CSVファイルの値を1行ずつ読み込み
    CSV.foreach(Rails.root.join('config','youtuber_list','youtuber_channels_data.csv')) do |data|
      url = data[1]
      p url
      charset = nil
      #begin-rescue　例外処理を行い、エラー内容をeに格納する
      begin
        html = open("https://www.youtube.com/channel/#{url}") do |f|
          charset = f.charset
          f.read
        end
      rescue OpenURI::HTTPError => e
      end
      #htmlをパース(解析)してオブジェクトを生成
      page = Nokogiri::HTML.parse(html,nil,charset)
      #cssセレクタ
      subscriber = page.css(".yt-subscription-button-subscriber-count-branded-horizontal").text
      #xpathでnodeを指定
      title_name = page.xpath('//title')
      channel_title = title_name.inner_text
      #行頭の空白と改行の間の文字を抽出
      channel_name = channel_title.gsub(/\s*(.*)\n.*/, '\1')
        if subscriber.match(/(\d+\.\d+)万/)
          number_of_registrant = subscriber.gsub('万', '\1000')
          #.をデリート
          number_of_registrant = number_of_registrant.delete(".")
          #整数
          number_of_registrant = number_of_registrant.to_i
        elsif subscriber.match(/(\d+)万/)
          #.がない場合の処理
          number_of_registrant = subscriber.gsub('万', '\10000')
          #整数
          number_of_registrant = number_of_registrant.to_i
        else
          #整数
          number_of_registrant = subscriber.to_i
        end
        p number_of_registrant
        number_of_registrants << [ number_of_registrant, channel_name, url]
    end
    #チャンネルが存在しない場合、要素を除去
    number_of_registrants.delete_if {|data| data[1] == ""}
    #登録者数順に並び変え
    number_of_registrants = number_of_registrants.sort_by{|data| data[0]}.reverse
    number_of_registrants.each do |subscriber|
      #登録者数が1万人以上の処理
      if subscriber[0] >= 10000
        #登録者数の整数を文字列に変える処理（gsubで置き換える場合は文字列でないといけない）
        subscriber[0] = subscriber[0].to_s
        #もし下4桁が0の場合
        if subscriber[0].match(/(\d*)[0]{4}$/)
          #下4桁の0を置き換え
          subscriber[0] = subscriber[0].gsub(/(\d*)[0]{4}$/, '\1万人')
          p subscriber[0]
        #下3桁が0の場合の処理
        elsif subscriber[0].match(/(\d*)[0]{3}$/)
          #下3桁の0を置き換え
          subscriber[0] = subscriber[0].gsub(/(\d*)([1-9])[0]{3}$/, '\1.\2万人')
          p subscriber[0]
        else
          "例外です"
        end
      else
        #1万人以下の処理
        subscriber[0] = "#{subscriber[0]}人"
        p subscriber[0]
      end
    end
    #ranktableに値を格納
    number_of_registrants.each do |data|
      unless Rank.exists?(channel_id: data[2])
        rank = Rank.create(number_of_registrant: data[0], name: data[1], channel_id: data[2])
      end
    end
  end
end
