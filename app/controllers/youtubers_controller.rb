class YoutubersController < ApplicationController
  #http
  require 'httpclient'

  def index
    @youtubers = Youtuber.all
    @category_id = VideoCategory.all
    # パラメータをmodels/youtuber.rbのモデルに渡す
    #@youtuber_search = Youtuber.search(params[:search])
      # 検索クエリ: params[:user][:name]
    if params[:youtuber] && params[:youtuber][:name]
      user_name = params[:youtuber][:name]
      @youtuber_search = Youtuber.where("name LIKE '%#{youtuber_name}%'")
    else
      @youtuber_search = Youtuber.all
    end
  end

  def show
    @youtuber = Youtuber.find_by(id: params[:id])
    @video = Video.find_by(youtuber_id: @youtuber.id)
    @category = VideoCategory.find_by(category: @video.video_category_id)
    #youtuberのいいね数をカウント
    @good_count = Like.where(youtuber_id: @youtuber.id).count
  end

  def category
    @category_id = VideoCategory.find_by(category: params[:category])
    @category = Video.where(video_category_id: @category_id.category)
    #@video_category = VideoCategory.find_by(category: @category.video_category_id)
  end

  def category_search
    @category = Video.find_by(video_category_id: params[:category])
  end

  def subscriber_ranking
    @subscriber = Youtuber.all
    @youtuber = Youtuber.find_by(channel_id: @subscriber.channel_id)
  end
end
