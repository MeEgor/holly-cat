class UserMailer < ApplicationMailer
  def confirmation_email user
      @user = user
      unless @user.confirmed?
        mail to: @user.email, subject: 'Welcome to Holy Cat site!'
      end
    end
end
