class SiteController < ApplicationController
  before_action :current_user

  def index
  end

  def about
  end

  def support
  end

  def terms
    if I18n.locale == "pt_BR"
      render "terms.pt_BR"
    else
      render "terms"
    end
  end

  def privacy
    if I18n.locale == "pt_BR"
      render "privacy.pt_BR"
    else
      render "privacy"
    end
  end

end
