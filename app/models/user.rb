class User < ActiveRecord::Base
  include SessionsHelper 

  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, 
    presence: true, 
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }

  validates :password, 
    length: { minimum: 6 }

  before_save do
    self.email.downcase!
  end

  before_create do
    self.remember_token = encrypt_token new_token
  end

end
