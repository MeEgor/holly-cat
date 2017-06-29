require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  include SessionsHelper

  def setup
    @user = User.create! email: 'foo@bar.com', password: 'foobar', password_confirmation: 'foobar'
  end

  test "get signin page when not signed in" do
    get :new
    assert_response :success
    assert_select "h1.content-header", "Sign in"
    assert_select "form"
  end

  test "get sign in page when already signed in" do
    @user.save
    sign_in @user
    get :new
    assert_redirected_to root_path
  end

  test "sign in with invalid data" do
    post :create, sessions: {
      email: '',
      password: ''
    }
    assert_response :success
    assert_select "div.alert-error"
  end

  test "sign in with valid data" do
    post :create, sessions: {
      email: @user.email,
      password: @user.password
    }
    assert_redirected_to root_path
  end

  test "should get destroy" do
    delete :destroy
    assert_redirected_to signin_path
  end

end
