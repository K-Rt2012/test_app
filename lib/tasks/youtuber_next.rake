namespace :youtuber_next do
  desc "youtuber_next(webサイト)のスクレイピング"
  task :task_youtuber_next => :environment do
    Encoding.default_external = 'utf-8'
    #Nokogiriライブラリの読み込み
    require 'nokogiri'
    # URLにアクセスするためのライブラリの読み込み
    require 'open-uri'
    #csvファイルを取り扱うためのライブラリ
    require 'csv'
    #active_supportのcore_ext/numeric/conversionsを読み込み
    require 'active_support/core_ext/numeric/conversions'
    #JavaScriptで生成されているものを解析できるジェムを読み込み
    require 'capybara/poltergeist'

    numbers = Array.new
    search_lists = Array.new
    charset = nil
    #begin-rescue　例外処理を行い、エラー内容をeに格納する
    begin
      html = open("https://youtubernext.jp/youtuber/") do |f|
        # 文字種別を取得
        charset = f.charset
        # htmlを読み込んで変数htmlに渡す
        f.read
      end
    rescue OpenURI::HTTPError => e
    end
    #htmlをパース(解析)してオブジェクトを生成
    page = Nokogiri::HTML.parse(html,nil,charset)
    #サーチリストの数をカウント
    count_number = page.xpath('//*[@class="search_list_ttl"]').count
    count_number = count_number+1
    count_number = 2..count_number
    count_number.each do |number|
    numbers << number
    end
    p numbers
    numbers.each do |number|
      page.xpath("/html/body/main/div/section[1]/div/article[#{number}]/ul/li/a").each do |node|
        #属性値を取得
        search_id = node[:href]
        #ハッシュのキーを取得
        category_key = search_id.gsub(/\Ahttps:\/\/youtubernext.jp\/(profession|genre|feature)\/(\w*|%.*)\//, '\2')
        #サーチカテゴリーを取得
        category = node.inner_text
        #ハッシュのキーを取得
        id_key = "search_id_#{category_key}"
          category = category.chomp
          p category
          category = category.gsub(/\t|\n|\d*件|\s/, "")
          p category
          key = "id"
          keyAry = [key, category_key, id_key]
          keyValue = [category_key, category, search_id]
          ary = [keyAry, keyValue].transpose
          p ary
          search_hash = Hash[*ary.flatten]
        search_lists << search_hash
      end
    end
    p search_lists

    search_lists.each do |search_list|
      begin
        html = open(search_list["search_id_#{search_list["id"]}"]) do |f|
          # 文字種別を取得
          charset = f.charset
          # htmlを読み込んで変数htmlに渡す
          f.read
        end
      rescue OpenURI::HTTPError => e
      end
      #htmlをパース(解析)してオブジェクトを生成
      page = Nokogiri::HTML.parse(html,nil,charset)
      File.open("page.html", "w") do |f|
        f.puts(html)
      end
      page_count = page_count.to_i
      page_counts = Array.new
      if page_count >= 2
        page_count = 1..page_count
        page_count.each do |page_number|
          page_counts << page_number
        end
      end
      p page_counts
      page_counts.each do |page_number|
        youtuber_page = open("https://youtubernext.jp/genre/#{search_list["id"]}/page/#{page_number}/")
        #サーチリストの数をカウント
        numbers_2 = Array.new
        count_number_2 = page.xpath('/html/body/main/div/section[1]/div/article').count
        count_number_2 = 1..count_number_2
        count_number_2.each do |number_2|
          numbers_2 << number_2
        end
        p numbers_2
        numbers_2.each do |number_2|
          page.xpath("/html/body/main/div/section[1]/div/article[#{number_2}]/a").each do |node|
            search_id_2 = node[:href]
            begin
              youtuber_html = open(search_id_2) do |f|
              # 文字種別を取得
              charset = f.charset
              # htmlを読み込んで変数htmlに渡す
              f.read
              end
            rescue OpenURI::HTTPError => e
            end
            #htmlをパース(解析)してオブジェクトを生成
            page_2 = Nokogiri::HTML.parse(youtuber_html,nil,charset)
            File.open("page_2.html", "w") do |f|
              f.puts(youtuber_html)
            end
            #チャンネル名を抽出
            youtuber_name = page_2.xpath("//*[@class='youtuber_single_head']/div/h1").inner_text
            youtuber_name = youtuber_name.gsub(/\s/, "")
            p youtuber_name
            #登録者数を抽出
            subscriber = page_2.xpath("//*[@class='youtuber_single_head']/div/p[1]").inner_text
            subscriber = subscriber.gsub(/チャンネル登録者数|\n|\s/, "")
            p subscriber
            #channel_idを抽出
            channel_id = page_2.xpath("//*[@class='youtuber_single_head']/div/p[2]").inner_text
            channel_id.match(/https:\/\/www.youtube.com\/channel\/((\w|-|_)*)/) do |id|
              channel_id = id[1]
            end
            p channel_id
            #video_id = page_2.xpath("//*[@id='player_uid_468842331_1']/div[4]/div").[]('style')
            #p video_id
          end
        end
      end
    end
  end
end