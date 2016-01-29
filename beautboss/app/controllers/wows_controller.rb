class WowsController < ApplicationController
  before_action :authenticate_user

  def create
    @wow = Wow.new(post: Post.find(params[:post_id]), user: @current_user)
    if @wow.save
      # puts @wow.errors.to_json
      respond_to do |format|
        # format.html { redirect_to wows_url }
        format.js
      end
    end
  end

  def destroy
    wow = Wow.find(params[:id])
    @post = wow.post
    wow.destroy if wow.user == @current_user
    respond_to do |format|
      # format.html { redirect_to wows_url }
      format.js
    end
  end

end
