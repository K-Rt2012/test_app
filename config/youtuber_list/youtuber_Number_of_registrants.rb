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
CSV.foreach('youtuber_channels_data.csv') do |data|
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
  #
  subscriber = page.css(".yt-subscription-button-subscriber-count-branded-horizontal").text
  #xpathでnodeを指定
  title_name = page.xpath('//title')
  channel_title = title_name.inner_text
  #行頭の空白と改行の間の文字を抽出
  channel_name = channel_title.gsub(/\s*(.*)\n.*/, '\1')
    p channel_name
    p subscriber
    if subscriber.match(/(\d+\.\d+)万/)
      number_of_registrant = subscriber.gsub('万', '\1000')
      #.をデリート
      number_of_registrant = number_of_registrant.delete(".")
      #3桁区切り
      number_of_registrant = number_of_registrant.to_s.reverse.gsub( /(\d{3})(?=\d)/, '\1,').reverse
    elsif subscriber.match(/(\d+)万/)
      #.がない場合の処理
      number_of_registrant = subscriber.gsub('万', '\10000')
      #3桁区切り
      number_of_registrant = number_of_registrant.to_s.reverse.gsub( /(\d{3})(?=\d)/, '\1,').reverse
    else
      number_of_registrant = number_of_registrant.to_s.reverse.gsub( /(\d{3})(?=\d)/, '\1,').reverse
      number_of_registrant = subscriber
    end
    p number_of_registrant
    number_of_registrants << [channel_name, url,　number_of_registrant]
end
#csvファイルを開き、UTF－8で変数number_of_registrantsのデータを書き込み
csv_format = CSV.open("youtuber_number_of_registrants.csv", "w:UTF-8") do |test|
  number_of_registrants.each do |number_of_registrant|
    test << number_of_registrant
    puts csv_format
  end
end