class YoutubersController < ApplicationController
  #http
  require 'httpclient'

  def index
    @youtubers = Youtuber.all
    @category_id = VideoCategory.all
    #@genle = Youtuber.includes(:genles).where('groups.id' => genle.id)
    if params[:youtuber_name]
      youtuber_name = params[:youtuber_name]
      # where likeであいまい検索
      @youtuber_search = Youtuber.where("name LIKE '%#{youtuber_name}%'")
    else
      @youtuber_search = Youtuber.first(50)
    end
  end

  def show
    @youtuber = Youtuber.find_by(id: params[:id])
    p @youtuber
    @video = Video.find_by(youtuber_id: @youtuber.id)
    p @video
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
def genle
  @genle_name = params[:genle_name]
  p @genle_name
  genle = Genle.find_by(name: params[:genle_name])
  p genle
  @genle_search = Youtuber.includes(:genles).where('genles.id' => genle.id)
  p @genle_search
end