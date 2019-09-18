Encoding.default_external = 'utf-8'
require 'nokogiri'
require 'open-uri'
require 'csv'

arr = Array.new
#CSVファイルの値を1行ずつ読み込み
CSV.foreach('youtuber_list_data.csv') do |data|
    name = data[0]
    url_id = data[1].split(",")
    if data[1].match(/UC\w|-|_*/)
      url = "https://www.youtube.com/channel/#{url_id[0]}"
    else
      url ="https://www.youtube.com/user/#{url_id[0]}"
    end
    charset = nil
    #begin-rescue　例外処理を行い、エラー内容をeに格納する
    begin
      html = open(url) do |f|
        charset = f.charset
        f.read
      end
    rescue OpenURI::HTTPError => e
    end
    page = Nokogiri::HTML.parse(html,nil,charset)
    video_ids = Array.new
  #xpathでnodeを指定
  page.xpath('//*[@id=dismissable]/div[@id="meta"]/h3/a[@id="video-title"]').each do |node|
    video_id = node[:href]
    puts video_id
    video_ids << [name, video_id.join]
  end
end
