class YoutubersController < ApplicationController
  #http
  require 'httpclient'

  def index
    @youtubers = Youtuber.all
  end

  def show
    @youtuber = Youtuber.find_by(id: params[:id])
    @api_id = "https://www.googleapis.com/youtube/v3/playlists?part=id&channelId=#{@youtuber.url}&key=AIzaSyBd1wcxiyGzgosb5Renoi4eH3hWph7hulY"
    client = HTTPClient.new()
    response_playlist = client.get(@api_id)
    response_str = response_playlist.body
    @response_hash = JSON.parse(response_str)
    #多次元ハッシュ取り出し方、配列"items"の0番目のインデックスを指定して取り出し
    @playlist_id = @response_hash["items"][0]["id"]
    api_video_id = "https://www.googleapis.com/youtube/v3/playlistItems?part=contentDetails&playlistId=#{@playlist_id}&key=AIzaSyBd1wcxiyGzgosb5Renoi4eH3hWph7hulY"
    response_video = client.get(api_video_id)
    response_video_str = response_video.body
    #JSON.parseとは、JSON(ジェイソン)形式の文字列をRubyのHash(ハッシュ)形式に変換するためのメソッド
    @response_video_hash = JSON.parse(response_video_str)
    #多次元ハッシュ取り出し方、配列"items"の0番目のインデックスを指定して取り出し
    @video_id = @response_video_hash["items"][0]["contentDetails"]["videoId"]
  end
end
