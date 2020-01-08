namespace :youtuber_rank_2 do
  desc "Rankテーブルにデータをクリエイトする"
  task :rank_task_2 => :environment do
    require 'csv'
    require 'httpclient'
    Encoding.default_external = 'utf-8'
    require 'active_support/core_ext/numeric/conversions'

    youtubers = Youtuber.all
    youtubers_id = Array.new
    youtubers_rank = youtubers.sort_by{|data| data.number_of_registrant}.reverse
    youtubers_rank.each.with_index do |youtuber_rank, i|
      p youtuber_rank.number_of_registrant
      unless youtuber_rank.number_of_registrant == 0
        Rank.find_or_create_by(name: youtuber_rank.name, channel_id: youtuber_rank.channel_id, number_of_registrant: youtuber_rank.number_of_registrant, youtuber_id: youtuber_rank.id)
      else
        youtuber_rank.number_of_registrant = "非表示"
        Rank.find_or_create_by(name: youtuber_rank.name, channel_id: youtuber_rank.channel_id, number_of_registrant: youtuber_rank.number_of_registrant, youtuber_id: youtuber_rank.id)
      end
    end
  end
end
