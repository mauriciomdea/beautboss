class Api::V1::UsersController < ApplicationController

  def show
    render json: User.find(params[:id]), root: false
  end

  def create
  end

  def update
  end

  def destroy
  end
end

# def default_serializer_options
#   {root: false}
# end