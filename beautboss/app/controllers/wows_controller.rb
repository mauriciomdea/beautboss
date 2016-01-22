class WowsController < ApplicationController
  before_action :authenticate_user

  def create
    # logger.debug "oi!"
    wow = Wow.new(post: params[:post_id], user: @current_user)
    # logger.debug wow.to_yaml
    if wow.save
      # logger.debug wow.errors
      respond_to do |format|
        # format.html { redirect_to wows_url }
        format.js
      end
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
