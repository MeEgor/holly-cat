class UsersController < ApplicationController
  def new
    redirect_to root_path if current_user
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      UserMailer.confirmation_email(@user).deliver_later
      flash[:success] = "Confirmation email was sent to #{ @user.email }. Please follow instructions in email."
      redirect_to signin_path
    else
      render :new
    end
  end

  def confirm
    user = User.find_by confirmation_token: params[:confirmation_token]
    if user
      user.confirm!
      redirect_to signin_path email: user.email
    end
  end

  private 

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
