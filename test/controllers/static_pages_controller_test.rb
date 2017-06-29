require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  include SessionsHelper

  def setup
    @user = User.new email: 'foo@bar.com', password: 'foobar', password_confirmation: 'foobar'
  end

  test "root page when user is not signed in" do
    get :index
    assert_redirected_to signin_path
  end

  test "root page when user is signed in" do
    @user.save
    sign_in @user
    get :index
    assert_response :success
    assert_select "h1.content-header", "Holly Cat!"
    assert_select "img#cat-img"
  end

end
