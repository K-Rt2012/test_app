class Youtuber < ApplicationRecord
  #dependent: :destroyはもしYoutuberがデータベースから削除されてしまった場合にYoutuberへのグッドも全て消えるようになる
  has_many :likes, dependent: :destroy
  #likesテーブルを中間テーブルとして経由してuserテーブルから情報を取ってくると言うことを表してます。
  has_many :liked_youtubers, through: :likes, source: :user
  def iine(user)
    likes.create(user_id: user.id)
  end
  def uniine(user)
    likes.find_by(user_id: user.id).destroy
  end
end

def self.search(search) #self.でクラスメソッドとしている
  if search # Controllerから渡されたパラメータが!= nilの場合は、titleカラムを部分一致検索
    Youtuber.where(['name LIKE ?', "%#{search}%"])
  else
    Youtuber.all
  end
end
