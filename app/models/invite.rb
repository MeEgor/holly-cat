class Invite < ActiveRecord::Base
  include SessionsHelper 
  include ActionView::Helpers::DateHelper

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, 
    presence: true, 
    format: { with: VALID_EMAIL_REGEX }

  validate :validate_user_already_exist
  validate :validate_invite_frequency, on:[:update]

  before_save do
    self.email.downcase!
    self.last_sent_time = Time.now
  end

  before_create do
    self.invite_token = new_token
  end

  after_save do
    UserMailer.invite_email(self).deliver_later
  end

  def use
    User.new email: email
  end

  def activate!
    update_attribute active: false
  end

  private

    def validate_user_already_exist
      unless User.find_by_email(email).nil?
        errors[:base] = "User with email #{ email } already exists"
      end
    end

    def validate_invite_frequency
      period = Rails.configuration.invite_frequency
      if last_sent_time && Time.now - last_sent_time < period
        errors[:base] = "Invite already sent. Next try in #{ distance_of_time_in_words(Time.now - last_sent_time, period, include_seconds: true) }"
      end
    end

end