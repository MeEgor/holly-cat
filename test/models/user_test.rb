require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new email: 'foo@bar.com', password: 'foobar', password_confirmation: 'foobar'
  end

  test "methods availability" do
    assert @user.respond_to?(:email)
    assert @user.respond_to?(:password_digest)
    assert @user.respond_to?(:password)
    assert @user.respond_to?(:password_confirmation)
    assert @user.respond_to?(:authenticate)
  end

  test "valid" do
    assert @user.valid?
  end

  test "invalid when email is not present" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "invalid emails" do
    emails = %w{ user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com }
    emails.each do |email|
      @user.email = email
      assert_not @user.valid?, "valid with invalid email #{ email }"
    end
  end

  test "valid emails" do
    emails = %w{ user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn }
    emails.each do |email|
      @user.email = email
      assert @user.valid?, "invalid with valid email #{ email }"
    end
  end

  test "email already taken" do
    user_with_same_email = @user.dup
    user_with_same_email.email.upcase!
    assert @user.save
    assert_not user_with_same_email.valid?
  end

  test "save user email in downcase" do
    email = "FOO@bar.CoM"
    @user.email = email
    @user.save
    assert_equal @user.email, email.downcase
  end

  test "invalid when password is not present" do
    @user.password = @user.password_confirmation = " "
    assert_not @user.valid?
  end

  test "password doesnt match confirmation" do
    @user.password_confirmation = "do not match"
    assert_not @user.valid?
  end

  test "password is too short" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticate with invalid password" do
    @user.save
    found_user = User.find_by_email @user.email
    assert_not found_user.authenticate "wrong password"
  end

  test "authenticate with valid password" do
    @user.save
    found_user = User.find_by_email @user.email
    assert_equal found_user, found_user.authenticate(@user.password)
  end

end
