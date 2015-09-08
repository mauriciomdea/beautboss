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

  def self.update_or_create(attributes)
    assign_or_new(attributes).save
  end

  def self.assign_or_new(attributes)
    user = first || new
    user.assign_attributes(attributes)
    user
  end
  
end
