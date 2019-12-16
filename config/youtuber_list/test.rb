require 'csv'
require 'httpclient'
Encoding.default_external = 'utf-8'

youtubers_data = Array.new
CSV.foreach('youtuber_next_data.csv').each do |data|
  p data[2]
  p data[0]
  p data[1]
  data[1] = data[1].gsub(/,|人/ ,"")
  data[1] = data[1].to_i
  p data[1]
  youtubers_data << data
end
#チャンネルが存在しない場合、要素を除去
youtubers_data.delete_if {|data| data[2].empty?}
youtubers_data = youtubers_data.sort_by{|data| data[1]}.reverse
youtubers_data.each do |subscriber|
  # 登録者数の整数を文字列に変える処理（gsubで置き換える場合は文字列でないといけない）
  subscriber[1] = subscriber[1].to_s
  # insertメソッドで指定の位置に差し込み
  subscriber[1] = subscriber[1].insert(-4, ",").reverse
  subscriber[1] = subscriber[1].insert(0, "人").reverse
  p subscriber[1]
end