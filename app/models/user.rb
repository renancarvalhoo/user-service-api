class User < ApplicationRecord
  before_create :generate_key

  has_secure_password

  def generate_key
    begin
      key = SecureRandom.base64
    end while self.class.exists?(key: key)
    self.key = key
  end
end
