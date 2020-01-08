class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :likes, dependent: :destroy
  #ikesテーブルを中間テーブルとして経由してyoutuberテーブルから情報を取ってくると言うことを表してます。
  has_many :liked_youtubers, through: :likes, source: :youtuber

   #ユーザーがyoutuberに対して既にいいねしているか
   def already_liked?(youtuber)
    #条件に一致するデータが存在するかどうかを調べたいときは、exists?を使う
    self.likes.exists?(youtuber_id: youtuber.id)
  end
end
