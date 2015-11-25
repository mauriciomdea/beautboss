class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound do 
    _not_found
  end

  rescue_from ActiveRecord::StatementInvalid do |exception|
    _error exception.message
  end

  rescue_from Exception do |exception|
    _error exception.message
  end

  def default_serializer_options
    {root: false}
  end

  private

    def authenticate_user
      current_user || _not_authorized
    end

    def current_user
      token = request.headers['HTTP_TOKEN']
      @current_user = Token.get_user(token) || User.from_token(token)
    end

    def verify_user
      if params[:id].to_i != @current_user.id
        _not_authorized
      end
    end

    def _not_authorized message = "Not Authorized"
      render json: {error: message}, status: 401
    end

    def _not_found message = "Not Found"
      render json: {error: message}, status: 404
    end

    def _error error = "Internal Server Error"
      render json: { error: error }.to_json, status: 500
    end

end
