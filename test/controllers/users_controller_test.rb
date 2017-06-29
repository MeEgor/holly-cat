require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include SessionsHelper

  def setup 
    @user = User.new email: "qwe@qwe.qwe", password: "qweqwe", password_confirmation: "qweqwe"
  end

  test "sign up page" do
    get :new
    assert_response :success
    assert_select "h1.content-header", "Wellcome new user!"
    assert_select "form"
  end

  test "get new user page when already signed in" do
    @user.save
    @user.confirm!
    sign_in @user
    get :new
    assert_redirected_to root_path
  end

  test "sign up with valid data" do
    assert_difference 'User.count' do
      post :create, user: {
        email: 'foo@bar.com',
        password: 'foobar',
        password_confirmation: 'foobar'
      }
    end

    assert_redirected_to signin_path
    assert_equal "Confirmation email was sent to foo@bar.com. Please follow instructions in email.", flash[:success]

    confirmation_email = ActionMailer::Base.deliveries.last
    assert_equal "Welcome to Holy Cat site!", confirmation_email.subject
    assert_equal 'foo@bar.com', confirmation_email.to[0]
  end

  test "sign up with invalid data" do
    assert_no_difference 'User.count' do
      post :create, user: {
        email: 'foo@bar.com',
        password: '',
        password_confirmation: ''
      }
    end
    assert_response :success
    assert_select "div.content-form-errors"
  end

  test "user confirmation" do
    @user.save
    assert_not @user.confirmed?
    get :confirm, confirmation_token: @user.confirmation_token
    assert_redirected_to signin_path(email: @user.email)
    assert User.find_by_email(@user.email).confirmed?
  end

end
