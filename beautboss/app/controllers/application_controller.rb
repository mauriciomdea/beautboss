class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # protect_from_forgery with: :exception

  private

    def authenticate_user
      current_user || _not_authorized
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    helper_method :current_user

    def verify_user
      if params[:id].to_i != @current_user.id
        _not_authorized
      end
    end

    def _not_authorized message = "Not Authorized"
      redirect_to sign_in_path, notice: message
    end

    def _not_found message = "Not Found"
      raise ActionController::RoutingError.new(message)
    end

    def _error error = "Internal Server Error"
      raise ActionController::RoutingError.new(error)
    end

end
