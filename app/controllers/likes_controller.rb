class LikesController < ApplicationController
  def create
    @youtuber =Youtuber.find_by(id: params[:id])
    @youtuber.iine(current_user)
    redirect_to("/youtubers/#{@youtuber.id}")
  end

  def destroy
    @youtuber_id = params[:id]
    @youtuber =Like.find_by(youtuber_id: params[:id], user_id: current_user.id)
    @youtuber.destroy
    redirect_to("/youtubers/#{@youtuber_id}")
  end
end
