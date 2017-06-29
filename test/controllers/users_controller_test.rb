require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include SessionsHelper

  test "sign up page" do
    get :new
    assert_response :success
    assert_select "h1.content-header", "Wellcome new user!"
    assert_select "form"
  end

  test "get new user page when already signed in" do
    user = User.create email: "qwe@qwe.qwe", password: "qweqwe", password_confirmation: "qweqwe"
    sign_in user
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

    assert_redirected_to root_path
    assert_equal "Wellcome to Holly Cat site, foo@bar.com!", flash[:success]
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

end
