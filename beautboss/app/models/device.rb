class Device < ActiveRecord::Base

  belongs_to :user

  enum platform: [:ios_dev, :ios, :android]

  validates_presence_of :user, :platform, :endpoint

  def arn
    if self.platform == 'android'
      ENV['AWS_SNS_GCM_ARN']
    else
      ENV['AWS_SNS_IOS_ARN']
    end
  end

  def push_notification msg
    sns = Aws::SNS::Client.new
    sns.publish(target_arn: self.endpoint, message: format_message(msg), message_structure: "json")
  end

  private

    def format_message msg 
      if self.platform == 'android'
        { default: { message: msg }.to_json, GCM: { data: { message: msg } }.to_json }.to_json
        # { default: { message: msg }.to_json, GCM: { notification: { title: msg } }.to_json }.to_json
        # { GCM: { data: { message: msg } } }
      else
        { default: msg, APNS_SANDBOX: { aps: { alert: msg, sound: "default", badge: 1 } }.to_json, APNS: { aps: { alert: msg, sound: "default", badge: 1 } }.to_json }.to_json
      end
    end

end
