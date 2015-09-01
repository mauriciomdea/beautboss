class Token

  def self.get_token(user, expiration=28)

    # Generates a random token
    token = SecureRandom.uuid
    # Assures token does not already exist
    while Rails.cache.read(token) do 
      token = SecureRandom.uuid
    end
    # Saves user associated to a token on Memcached
    Rails.cache.write(token, user, expires_in: expiration.days)
    return token

  end

  def self.get_user(token)
    Rails.cache.read(token) unless token.nil?
  end

  def self.destroy_token(token)

    Rails.cache.delete(token) unless token.nil?

  end

end
