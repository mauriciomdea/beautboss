class User < ActiveRecord::Base
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates_presence_of :password, :on => :create

  def self.authenticate(email, password)
    user = User.find_by(email: email).try(:authenticate, password)
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
