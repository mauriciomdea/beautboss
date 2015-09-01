class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  private

    def authenticate_user

      current_user || _not_authorized

    end

    def current_user

      token = request.headers['HTTP_TOKEN'] || request.headers['HTTP_SESSION_ID']
      @current_user = Token.get_user(token) || User.from_token(token)
      
    end

    def _not_authorized message = "Not Authorized"

      render json: {error: message}, status: 401

    end

    def _not_found message = "Not Found"

      # render nothing: true, status: 404
      render json: {error: message}, status: 404
      
    end

end
