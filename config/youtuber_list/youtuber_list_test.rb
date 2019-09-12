Encoding.default_external = 'utf-8'
require 'nokogiri'
require 'open-uri'
require 'csv'

CSV.foreach('youtuber_list.csv') do |data|
    name = data[0]
    url = data[1]
    charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read
    end
    page = Nokogiri::HTML.parse(html,nil,charset)
    arr = Array.new
  #youtuber_nameとリンク先のURLを取得
  linked_url = page.at('//*[@id="entry"]/section/table//a').get_attribute('href')
    #linked_url = node[:href]
    if /\Ahttps:\/\/www.youtube.com\/channel/ === linked_url
      channel_id = linked_url.post_match(/\Ahttps:\/\/www.youtube.com\/channel/)
    elsif /\Ahttps:\/\/www.youtube.com\/user/ === linked_url
      channel_id = linked_url.post_match(/\Ahttps:\/\/www.youtube.com\/user/)
    end
  arr << [name, channel_id]
  p arr
end
csv_format = CSV.open("youtuber_list_data.csv", "w:UTF-8") do |list|
  arr.each do |data|
    list << data
    puts csv_format
  end
end  

