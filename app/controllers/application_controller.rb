class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # 第 1 引数 => model名 :youtuber (必須)
  # 第 2 引数 => column名 :name (必須)
  # 第 3 引数 => オプション full: true (任意)
  autocomplete :youtuber, :name, full: true # 追加
end
