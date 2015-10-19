class User < ActiveRecord::Base
  has_secure_password validations: false

  validates :name, presence: true
  validates :email, uniqueness: true
  validates :email, presence: true, if: 'facebook.nil?'
  validates :password, presence: true, if: 'facebook.nil?'

  has_many :posts, dependent: :delete_all
  has_many :wows, dependent: :delete_all
  has_many :comments, dependent: :delete_all

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
                                    dependent:   :destroy
  has_many :notifications,  -> { order(created_at: :desc) },
                            class_name:  'Activity',
                            foreign_key: 'user_id'

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

  def self.authenticate(email, password)
    user = User.find_by(email: email).try(:authenticate, password)
  end

  def self.from_token(token)
    user_from_cache = Rails.cache.read(token) unless token.nil?
  end

  # Find or create User

  def self.update_or_create(attributes)
    assign_or_new(attributes).save
  end

  def self.assign_or_new(attributes)
    user = first || new
    user.assign_attributes(attributes)
    user
  end
  
end
