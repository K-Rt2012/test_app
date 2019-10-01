class YoutubersController < ApplicationController
  #http
  require 'httpclient'

  def index
    @youtubers = Youtuber.all
  end

  def show
    @youtuber = Youtuber.find_by(id: params[:id])
    @video = Video.find_by(youtuber_id: @youtuber.id)
    @category = VideoCategory.find_by(category: @video.video_category_id)
    #youtuberのいいね数をカウント
    @good_count = Like.where(youtuber_id: @youtuber.id).count
  end
end
