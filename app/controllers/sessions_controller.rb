class SessionsController < ApplicationController

  def new
    redirect_to root_path if current_user
    @email = params[:email]
  end

  def create
    user = User.find_by_email params[:sessions][:email]
    if user && user.authenticate(params[:sessions][:password])
      sign_in user
      redirect_to root_path
    else
      flash.now[:error] = "Wrong email or password"
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to signin_path
  end
end
