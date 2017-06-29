class UserMailer < ApplicationMailer

  def confirmation_email user
    @user = user
    unless @user.confirmed?
      mail to: @user.email, subject: 'Welcome to Holy Cat site!'
    end
  end

  def invite_email invite
    @invite = invite
    mail to: @invite.email, subject: 'You was invited to Holy Cat site!'
  end

end
