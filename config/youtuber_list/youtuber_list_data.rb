#Windowsではデフォルトで外部エンコーディングが「Windows-31J」に設定されているため、UTF-8に設定
#「外部エンコーディング」、入出力ファイルの文字コードを表す。
#「内部エンコーディング」、ソース内部で扱う文字列の文字コードを表す。
Encoding.default_external = 'utf-8'
require 'nokogiri'
require 'open-uri'
require 'csv'

arr = Array.new
#CSVファイルの値を1行ずつ読み込み
CSV.foreach('youtuber_list.csv') do |data|
    name = data[0]
    url = data[1]
    charset = nil
    begin
      html = open(url) do |f|
        charset = f.charset
        f.read
      end
    rescue OpenURI::HTTPError => e
    end
    page = Nokogiri::HTML.parse(html,nil,charset)
    channel_ids = Array.new
  #xpathでnodeを指定
  page.xpath('//*[@id="entry"]/section/table//a').each do |node|
    #nodeのhref属性を取得
    linked_url = node[:href]
    if /\Ahttps:\/\/www.youtube.com\/channel/ === linked_url
      channel_id = linked_url.gsub(/\Ahttps:\/\/www.youtube.com\/channel\/((\w|-)*)\/*.*/, '\1')
    elsif /\Ahttps:\/\/www.youtube.com\/user/ === linked_url
      channel_id = linked_url.gsub(/\Ahttps:\/\/www.youtube.com\/user\/((\w|-)*)\/*.*/, '\1')
    end
    if channel_id != nil
      channel_ids << channel_id
    end
  end
  arr << name
  arr << channel_ids
end
csv_format = CSV.open("youtuber_list_data.csv", "w:UTF-8") do |test|
  arr.each do |youtuber_data|
    test << youtuber_data
    puts csv_format
  end
end


