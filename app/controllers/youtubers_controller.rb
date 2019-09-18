class YoutubersController < ApplicationController

  def index
    @list = List.all
  end

  def show
    @list = List.find_by(id: params[:id])
    #url_id = @list.url.split(",")
    require 'httpclient'
    @channel_id = "https://www.googleapis.com/youtube/v3/channels?part=statistics&id=UCWdFb_w3JI1BPTiBCXERg2Q&key=AIzaSyBd1wcxiyGzgosb5Renoi4eH3hWph7hulY"
    client = HTTPClient.new()
    @response = client.get(@channel_id)
    puts @response.body
  end

end
