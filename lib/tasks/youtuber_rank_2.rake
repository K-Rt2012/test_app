namespace :youtuber_rank_2 do
  desc "Rankテーブルにデータをクリエイトする"
  task :rank_task_2 => :environment do
    require 'csv'
    require 'httpclient'
    Encoding.default_external = 'utf-8'
    require 'active_support/core_ext/numeric/conversions'

    youtubers_data = Array.new
    CSV.foreach(Rails.root.join('config','youtuber_list','youtuber_next_data.csv')).with_index do |data, i|
      p data[2]
      p data[0]
      p data[1]
      p i
      data[1] = data[1].gsub(/,|人/ ,"")
      data[1] = data[1].to_i
      p data[1]
      youtubers_data << [data[0], data[1], data[2], i]
    end
    #チャンネルが存在しない場合、要素を除去
    youtubers_data.delete_if {|data| data[2].empty?}
    youtubers_data = youtubers_data.sort_by{|data| data[1]}.reverse
    youtubers_data.each do |subscriber|
      unless subscriber[1] == 0
        #3桁区切り
        subscriber[1] = subscriber[1].to_s(:delimited)
        p subscriber[1]
        # 登録者数の整数を文字列に変える処理
        subscriber[1] = subscriber[1].to_s
        subscriber[1] = subscriber[1].reverse
        # insertメソッドで指定の位置に差し込み
        subscriber[1] = subscriber[1].insert(0, "人").reverse
        p subscriber[1]
        Rank.find_or_create_by(name: subscriber[0], channel_id: subscriber[2], number_of_registrant: subscriber[1], youtuber_id: subscriber[3])
      else
        subscriber[1] = "非表示"
        Rank.find_or_create_by(name: subscriber[0], channel_id: subscriber[2], number_of_registrant: subscriber[1], youtuber_id: subscriber[3])
      end
    end
  end
end
