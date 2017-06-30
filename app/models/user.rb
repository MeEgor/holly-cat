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
    self.confirmation_token = new_token unless self.skip_confirmation
  end

  after_create do
    UserMailer.confirmation_email(self).deliver_later
  end

  attr_accessor :skip_confirmation

  def confirmed?
    confirmation_token.nil?
  end

  def confirm!
    update_attribute :confirmation_token, nil
  end

  def skip_confirmation!
    @skip_confirmation = true
  end

end
