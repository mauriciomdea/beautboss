class TemporaryPassword < ActiveRecord::Base
  before_create :generate_password

  belongs_to :user

  validates_presence_of :user, :password, :expire_at
  validates_uniqueness_of :password
  validates :password, length: { maximum: 191 }

  private

    def generate_password
      self.password = SecureRandom.hex(8)
      while TemporaryPassword.find_by(password: self.password)
        self.password = SecureRandom.hex(8)
      end
      self.expire_at = Time.now + 2.days
    end

end
