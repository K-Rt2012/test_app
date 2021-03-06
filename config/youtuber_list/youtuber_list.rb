require 'nokogiri'
require 'open-uri'
require 'csv'

url = "https://youtuberotaku.com/youtuber-list"

charset = nil
html = open(url) do |f|
  charset = f.charset
  f.read
end

page = Nokogiri::HTML.parse(html,nil,charset)
arr = Array.new

#youtuber_nameとリンク先のURLを取得
page.xpath('//a').each do |node|
  name = node.inner_text
  linked_url = node[:href]
  #データをarrクラスに格納
  arr << [name, linked_url]
end

#csvファイル形式で生成
#csv_format = CSV.generate do |data|
  #arr.each do |line|
    #data << line
  #end
#end
#puts csv_format

#csvファイルを開き、UTF－8で書き込むよう定義。
#arrデータをcsvファイルに書き込み
csv_format = CSV.open("youtuber_list.csv", "w:UTF-8") do |test|
    arr.each do |data|
    test << data
    puts csv_format
  end
end
