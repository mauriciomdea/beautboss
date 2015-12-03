class User < ActiveRecord::Base
  has_secure_password validations: false

  before_validation :generate_username

  validates :name, presence: true
  validates :email, uniqueness: true, unless: 'email.nil?'
  validates :email, presence: true, if: 'facebook.nil?'
  validates :password, presence: true, if: 'facebook.nil? && password_digest.nil?'
  validates :facebook, presence: true, if: 'password.nil? && password_digest.nil?'
  validates :facebook, uniqueness: true, unless: 'facebook.nil?'
  validates :username, uniqueness: true, presence: true

  validates :name, :email, :username, length: { maximum: 191 }
  validates :avatar, :bio, length: { maximum: 767 }
  validates :password, length: { in: 4..16 }, unless: 'password.nil?'

  has_many :posts, dependent: :delete_all
  has_many :wows, dependent: :delete_all
  has_many :comments, dependent: :delete_all
  has_many :devices, dependent: :delete_all

  has_many :outbound_relationships, class_name:  'Relationship',
                                    foreign_key: 'follower_id',
                                    dependent:   :destroy
  has_many :inbound_relationships, class_name:  'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent:   :destroy

  has_many :following, through: :outbound_relationships,  source: :followed
  has_many :followers, through: :inbound_relationships, source: :follower

  has_many :activities, class_name: 'Activity',
                                    foreign_key: 'actor_id',
                                    dependent: :delete_all
  has_many :notifications,  -> { where("actor_id != user_id") },
                            class_name:  'Activity',
                            foreign_key: 'user_id'

  # def to_param
  #   username # or name.parameterize
  # end

  def generate_username
    username = name.parameterize.underscore unless name.nil?
    i = 1
    while User.find_by(username: username) 
      username = "#{username}#{i}"
      i += 1
    end
    self.username ||= username
  end

  def to_param
    username
  end

  # Follows a user
  def follow(other_user)
    outbound_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user
  def unfollow(other_user)
    outbound_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user
  def following?(other_user)
    following.include?(other_user)
  end

  # Authentication stuff

  # def self.authenticate(email, password)
  #   user = User.find_by(email: email).try(:authenticate, password)
  # end

  def self.from_token(token)
    user_from_cache = Rails.cache.read(token) unless token.nil?
  end

  # Find or create User from Facebook

  def self.from_facebook(profile)
    if profile.email.nil?
      user = User.where(facebook: profile.id).first || User.new
    else
      user = User.where(facebook: profile.id).first || User.where(email: profile.email).first || User.new
    end
    user.facebook = profile.id unless profile.id.nil?
    user.email = profile.email unless profile.email.nil?
    user.name = profile.name unless profile.name.nil?
    user.bio = profile.bio unless profile.bio.nil?
    user.avatar = profile.picture.url unless profile.picture.nil?
    user.website = profile.website unless profile.website.nil?
    user.location = profile.location.name unless profile.location.nil?
    user
  end
  
end
