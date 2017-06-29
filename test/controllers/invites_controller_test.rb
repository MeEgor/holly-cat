require 'test_helper'

class InvitesControllerTest < ActionController::TestCase

  def setup
    @user = User.new email: "qwe@wqe.qwe", password: "qweqwe", password_confirmation: "qweqwe"
    @user.skip_confirmation!
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_select "h1.content-header", "Invite your friend!"
    assert_select "form"
  end

  test "invite friend" do
    post :create, invite: {
      email: 'asd@asd.com'
    }
    assert_redirected_to root_path
    assert_equal "Invite was successfully sent to asd@asd.com.", flash[:success]

    invite_imail = ActionMailer::Base.deliveries.last
    assert_equal "You was invited to Holy Cat site!", invite_imail.subject
    assert_equal 'asd@asd.com', invite_imail.to[0]
  end

  test "invite already existed user" do
    @user.save
    post :create, invite: {
      email: @user.email
    }
    assert_response :success
    assert_select "div.content-form-errors"
  end

  test "invite already invited friend" do
    invite = Invite.create email: "asd@asd.asd"
    post :create, invite: {
      email: invite.email
    }
    assert_response :success
    assert_select "div.content-form-errors"
  end

end
