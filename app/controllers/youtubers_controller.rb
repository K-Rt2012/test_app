class YoutubersController < ApplicationController
  require 'httpclient'
  def index
    @youtubers = Youtuber.all
    @category_id = VideoCategory.all
    @genle_category = GenleCategory.all
    @genle = Genle.new
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
  end

  def category_search
    @category = Video.find_by(video_category_id: params[:category])
  end

  def subscriber_ranking
    @rank = Rank.all
    #@youtuber = Youtuber.find_by(channel_id: @rank.channel_id)
  end
  def genle
    @genle_name = params[:genle_name]
    p @genle_name
    genle = Genle.find_by(name: params[:genle_name])
    p genle
    @genle_search = Youtuber.includes(:genles).where('genles.id' => genle.id)
    p @genle_search
  end
  def name
    @is_pagenate = false
    @page = params[:page]
    if params[:youtuber_name]
      youtuber_name = params[:youtuber_name]
      # where likeであいまい検索
      @youtuber_search = Youtuber.where("name LIKE '%#{youtuber_name}%'").page(@page).per(20)
      @is_pagenate = true
    else
      @youtuber_search = Youtuber.first(20)
    end
  end
end