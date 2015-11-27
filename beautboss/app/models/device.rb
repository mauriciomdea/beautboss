class Device < ActiveRecord::Base

  belongs_to :user

  enum device_type: [:ios_dev, :ios, :android]

  validates_presence_of :user, :device_type, :device_token

end
