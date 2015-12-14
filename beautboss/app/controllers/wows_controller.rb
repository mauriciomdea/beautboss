class WowsController < ApplicationController
  before_action :authenticate_user

  def create
    Wow.create(post: params[:post_id], user: @current_user)
    respond_to do |format|
      # format.html { redirect_to wows_url }
      format.js
    end
  end

  def destroy
    wow = Wow.find(params[:id])
    wow.destroy if wow.user == @current_user
    respond_to do |format|
      # format.html { redirect_to wows_url }
      format.js
    end
  end

end
