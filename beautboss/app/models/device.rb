class Device < ActiveRecord::Base

  belongs_to :user

  enum platform: [:ios_dev, :ios, :android]

  validates_presence_of :user, :platform, :endpoint
  validates_uniqueness_of :endpoint

  def arn
    if self.platform == 'android'
      ENV['AWS_SNS_GCM_ARN']
    elsif self.platform == 'ios'
      ENV['AWS_SNS_IOS_ARN']
    elsif self.platform == 'ios_dev'
      ENV['AWS_SNS_DEV_ARN']
    else
      nil
    end
  end

  def push_notification msg, data
    sns = Aws::SNS::Client.new
    logger.info("Notification: #{self.user.username}: #{self.arn}: #{msg}")
    sns.publish(target_arn: self.endpoint, message: format_notification(msg, data), message_structure: "json")
  end

  private

    def format_notification msg, data 
      badges = self.user.notifications.where(read: false).count
      if self.platform == 'android'
        { default: { message: msg }.to_json, GCM: { data: { message: data } }.to_json }.to_json
        # { default: { message: msg }.to_json, GCM: { notification: { title: msg } }.to_json }.to_json
        # { GCM: { data: { message: msg } } }
      else
        { default: data, APNS_SANDBOX: { aps: { alert: msg, sound: "default", badge: badges } }.to_json, APNS: { aps: { alert: msg, sound: "default", badge: badges } }.to_json }.to_json
      end
    end

end
