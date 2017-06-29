module SessionsHelper

  def sign_in user
    token = new_token
    user.update_attribute :remember_token, encrypt_token(token)
    cookies[:remember_token] = token
    self.current_user = user
  end

  def sign_out
    cookies[:remember_token] = nil
    self.current_user = nil
  end

  def current_user= user
    @current_user = user
  end

  def current_user
    user = User.find_by remember_token: encrypt_token(cookies[:remember_token])
    @current_user ||= user
  end

  def signin!
    redirect_to signin_path unless current_user
  end

  def new_token
    SecureRandom.hex
  end

  def encrypt_token token
    Digest::SHA1.hexdigest token.to_s
  end

end
