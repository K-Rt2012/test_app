#Windowsではデフォルトで外部エンコーディングが「Windows-31J」に設定されているため、UTF-8に設定
#「外部エンコーディング」、入出力ファイルの文字コードを表す。
#「内部エンコーディング」、ソース内部で扱う文字列の文字コードを表す。
Encoding.default_external = 'utf-8'
require 'nokogiri'
require 'open-uri'
require 'csv'

channels = Array.new
users = Array.new
#CSVファイルの値を1行ずつ読み込み
CSV.foreach('youtuber_list.csv') do |data|
    url = data[1]
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
    channel_ids = Array.new
    user_ids = Array.new
  #xpathでnodeを指定
  page.xpath('//*[@id="entry"]/section/table//a').each do |node|
    #nodeのhref属性を取得
    linked_url = node[:href]
    if /\Ahttps:\/\/www.youtube.com\/channel/ === linked_url
      name = node.inner_text
      channel_id = linked_url.gsub(/\Ahttps:\/\/www.youtube.com\/channel\/((\w|-)*)\/*.*/, '\1')
      channel_ids << name
      channel_ids << channel_id.to_s
    elsif /\Ahttps:\/\/www.youtube.com\/user/ === linked_url
      name = node.inner_text
      user_id = linked_url.gsub(/\Ahttps:\/\/www.youtube.com\/user\/((\w|-)*)\/*.*/, '\1')
      user_ids << name
      user_ids << user_id
    end
  end
  #joinでchannnel_idsのデータを文字列にする(csvファイルには文字列でないと書き込めないため)
  channels << channel_ids
  users << user_ids
  #dekete_ifで[]の配列を除去
  channels.delete_if {|data|
    data == []
  }
  users.delete_if {|data|
    data == []
  }
end
#csvファイルを開き、UTF－8で変数channelsのデータを書き込み
csv_format = CSV.open("youtuber_users_data.csv", "w:UTF-8") do |test|
  users.each do |youtuber_data|
    test << youtuber_data
    puts csv_format
  end
end
#csvファイルを開き、UTF－8で変数usersのデータを書き込み
csv_format = CSV.open("youtuber_channels_data.csv", "w:UTF-8") do |test|
  channels.each do |youtuber_data|
    test << youtuber_data
    puts csv_format
  end
end



