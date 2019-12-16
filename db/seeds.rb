# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'
require 'httpclient'
def fatch_genle_category(genle_name)
  if genle_name.match(/ペット|猫|犬|ハムスター|うさぎ|鳥|野生動物/)
    GenleCategory.find(11)
  elsif genle_name.match(/野球|サッカー|バスケ|ゴルフ|自転車|バイク|自動車|旅行|キャンプ|釣り|自然|格闘技|陸上競技|スノボ|スポーツ/)
    GenleCategory.find(12)
  elsif genle_name.match(/美容|メイク|ファッション|美容師|ダイエット|筋トレ|健康|医療/)
    GenleCategory.find(1)
  elsif genle_name.match(/料理|お菓子|お酒|食レポ|大食い/)
    GenleCategory.find(10)
  elsif genle_name.match(/DIY|商品紹介|ガジェット|投資|英語|外国語|教育|科学|自己啓発|ビジネス|ニュース/)
    GenleCategory.find(5)
  elsif genle_name.match(/パチンコ|競馬|鉄道|プラレール|トミカ|レゴ|工作|イラスト|おもちゃ|スクイーズ|クレーン|ディズニー/)
    GenleCategory.find(2)
  elsif genle_name.match(/歌|ピアノ|ドラム|楽器（その他）|ダンス|EDM|BGM|ボーカロイド/)
    GenleCategory.find(9)
  elsif genle_name.match(/おもしろ|生配信|物申す|不思議|恋愛|コスプレ|セクシー/)
    GenleCategory.find(6)
  elsif genle_name.match(/ゲーム実況|FPS|任天堂|ホラゲー|ガチャ|ポケモン|マイクラ|パワプロ|パズドラ|モンスト|PUBG|荒野行動|FORTNITE|クラロワ|サバゲ―|スマホゲー|DBD|FGO|スクエニ|スプラトゥーン|マリオ|スマブラ|Apex|CoD|モンハン|eスポーツ|フォートナイト|デッドバイデイライト/)
    GenleCategory.find(7)
  elsif genle_name.match(/バーチャル|ASMR|アニメ|エンタメ作品|ゆっくり|遊戯王|TCG/)
    GenleCategory.find(8)
  elsif genle_name.match(/主婦|女子学生|男子学生|カップル|外国人|LGBT|芸能人|企業公式|ホスト|子ども|アイドル|エリア/)
    GenleCategory.find(4)
  elsif genle_name.match(/原宿|韓国|台湾|海外/)
    GenleCategory.find(3)
  elsif genle_name.match(/男性|女性|可愛い|美人|イケメン|有名芸能人|国会議員|医師|弁護士|薬剤師|税理士|弁理士|社労士|公認会計士/)
    GenleCategory.find(13)
  else
    GenleCategory.find(13)
  end
end
p VideoCategory.create(category: 1, name: "映画とアニメ")
p VideoCategory.create(category: 2, name: "自動車と乗り物")
p VideoCategory.create(category: 10, name: "音楽")
p VideoCategory.create(category: 15, name: "ペットと動物")
p VideoCategory.create(category: 17, name: "スポーツ")
p VideoCategory.create(category: 19, name: "旅行とイベント")
p VideoCategory.create(category: 20, name: "ゲーム")
p VideoCategory.create(category: 22, name: "ブログ")
p VideoCategory.create(category: 23, name: "コメディー")
p VideoCategory.create(category: 24, name: "エンターテイメント")
p VideoCategory.create(category: 25, name: "ニュースと政治")
p VideoCategory.create(category: 26, name: "ハウツーとスタイル")
p VideoCategory.create(category: 27, name: "教育")
p VideoCategory.create(category: 28, name: "科学と技術")

GenleCategory.create(id: 1, name: "美容・健康")
GenleCategory.create(id: 2,name: "趣味・遊び")
GenleCategory.create(id: 3,name: "エリア")
GenleCategory.create(id: 4,name: "パーソナリティ")
GenleCategory.create(id: 5,name: "実用・教養")
GenleCategory.create(id: 6,name: "エンタメ")
GenleCategory.create(id: 7,name: "ゲーム")
GenleCategory.create(id: 8,name: "バーチャル・サブカル")
GenleCategory.create(id: 9,name: "音楽")
GenleCategory.create(id: 10,name: "料理・食事")
GenleCategory.create(id: 11,name: "ペット・動物")
GenleCategory.create(id: 12,name: "スポーツ・野外")
GenleCategory.create(id: 13,name: "その他")

CSV.foreach(Rails.root.join('config', 'youtuber_list', 'youtuber_next_data.csv')) do |youtuber_data|
  p youtuber_data[2]
  #youtuberstableに登録されているデータを弾く処理
  unless Youtuber.exists?(channel_id: youtuber_data[2])
    #配列の要素を数える
    numbers = youtuber_data.count
    p numbers
    a = youtuber_data[3]
    genles = Array.new
    if numbers >= 3
      numbers = 3..numbers
      numbers.each do |number|
        p youtuber_data[number]
        genles << youtuber_data[number]
      end
      p genles
      a = genles.map do |genle|
        # present オブジェクトであるレシーバーの値が存在すればtrue、存在しなければfalseを返すメソッド
        if genle.present?
          # find_or_create_by
          # 定義しているモデル(Genle)のカラム内に(name)に引数(genle)が存在しないならcreateする
          Genle.find_or_create_by(name: genle, genle_category_id: fatch_genle_category(genle).id)
        end
      # compact 配列からnilを除去するメソッド
      end.compact
    end
    p a.first.reload
    p a
    youtuber_data[1].gsub!(/,|人/, "")
    youtuber_data[1].to_i
    p youtuber_data[1]
    Youtuber.find_or_create_by(name: youtuber_data[0], number_of_registrant: youtuber_data[1], channel_id: youtuber_data[2], genles: a)
  end
end
CSV.foreach(Rails.root.join('config', 'youtuber_list', 'video_data.csv')) do |video_data|
  p video_data[0]
  category = VideoCategory.find_by(category: video_data[2])
  youtuber = Youtuber.find_by(channel_id: video_data[3])
  next unless youtuber.present?
  Video.find_or_create_by(video_id: video_data[0], video_title: video_data[1], youtuber_id: youtuber.id, video_category_id: category.category)
end