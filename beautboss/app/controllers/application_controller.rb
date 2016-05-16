class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # protect_from_forgery with: :exception

  before_action :set_locale

  def set_locale
    # I18n.locale = "pt_BR"
    unless current_user.nil?
      I18n.locale = current_user.locale
    else
      I18n.locale = extract_locale_from_tld || I18n.default_locale
    end
  end
   
  # Get locale from top-level domain or return nil if such locale is not available
  # You have to put something like:
  #   127.0.0.1 application.com
  #   127.0.0.1 application.it
  #   127.0.0.1 application.pl
  # in your /etc/hosts file to try this out locally
  def extract_locale_from_tld
    parsed_locale = request.host.split('.').last
    # I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
    if parsed_locale == 'br'
      "pt_BR"
    else
      "en"
    end
  end

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
