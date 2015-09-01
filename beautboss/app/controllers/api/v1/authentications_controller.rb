class Api::V1::AuthenticationsController < ApplicationController

  def create

    if user = User.authenticate(params[:email], params[:password])
      @token = Token.get_token(user)
      render json: {token: @token}, status: :created, root: false
    else
      head :not_found
    end

  end

  def destroy

    Token.destroy_token(params[:id])
    head :no_content

  end

end
