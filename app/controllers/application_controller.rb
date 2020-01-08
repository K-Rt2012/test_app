class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # 第 1 引数 => model名 :youtuber (必須)
  # 第 2 引数 => column名 :name (必須)
  # 第 3 引数 => オプション full: true (任意)
  autocomplete :youtuber, :name, full: true # 追加
  def after_sign_in_path_for(resource)
    youtubers_path # ログイン後に遷移するpathを設定
  end

  def after_sign_out_path_for(resource)
    youtubers_path # ログアウト後に遷移するpathを設定
  end
end
