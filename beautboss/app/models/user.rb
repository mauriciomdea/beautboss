class User < ActiveRecord::Base

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  def self.authenticate(email, password)
    user = User.where(email: email, password: password).first
  end

  def self.from_token(token)
    user_from_cache = Rails.cache.read(token) unless token.nil?
  end
  
end
