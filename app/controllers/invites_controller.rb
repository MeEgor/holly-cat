class InvitesController < ApplicationController

  before_action :signin!

  def new
    @invite = Invite.new
  end

  def create
    @invite = Invite.find_by(email: invite_params[:email], active: true) || Invite.new(invite_params)

    if @invite.save
      flash[:success] = "Invite was successfully sent to #{ @invite.email }."
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @invite = Invite.find_by_invite_token params[:id]
    if @invite
      @user = @invite.use
    else
      redirect_to signup_path, notice: "Can not find invite, try to sign up yourself"
    end
  end

  def update
    @invite = Invite.find_by_invite_token params[:id]
    if @invite
      @user = User.new user_params
      @user.skip_confirmation! if @user.email == @invite.email
      if @user.save
        @invite.activate!
        sign_in(@user) if @user.confirmed?
        redirect_to root_path
      else
        render :show
      end
    else
      redirect_to signup_path, notice: "Can not find invite, try to sign up yourself"
    end
  end

  private 

    def invite_params
      params.require(:invite).permit(:email)
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

end
