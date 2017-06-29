require 'test_helper'

class InviteTest < ActiveSupport::TestCase

  def setup
    @invite = Invite.new email: "asd@asd.asd"
  end

  test "valid" do
    assert @invite.valid?
  end

  test "invalid without email" do
    @invite.email = " "
    assert_not @invite.valid?
  end

  test "invalid with this emails" do
    emails = %w{ user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com }
    emails.each do |email|
      @invite.email = email
      assert_not @invite.valid?, "valid with invalid email #{ email }"
    end
  end

  test "valid with this emails" do
    emails = %w{ user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn }
    emails.each do |email|
      @invite.email = email
      assert @invite.valid?, "invalid with valid email #{ email }"
    end
  end

  test "save email in downcase" do
    email = "FOO@bar.CoM"
    @invite.email = email
    @invite.save
    assert_equal @invite.email, email.downcase
  end

  test "should have invite_token" do
    @invite.save
    assert_not @invite.invite_token.nil?
  end

  test "should have last_sent_time" do
    @invite.save
    assert_not @invite.last_sent_time.nil?
  end

  test "use should return User instance with proper email" do
    user = @invite.use
    assert_equal user.email, @invite.email
  end

end