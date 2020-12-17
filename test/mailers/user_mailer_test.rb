require 'test_helper'
require 'base64'

class UserMailerTest < ActionMailer::TestCase
  def setup
    @user = users(:michael)
    @user.activation_token = User.new_token
    @user.reset_token = User.new_token
    @activation_mail = UserMailer.account_activation(@user)
    @reset_mail = UserMailer.password_reset(@user)
  end


  test "account_activation" do
    assert_equal "Account activation", @activation_mail.subject
    assert_equal [@user.email], @activation_mail.to
    assert_equal ["noreply@example.com"],  @activation_mail.from
    assert_match @user.name,               @activation_mail.body.encoded
    assert_match @user.activation_token,   @activation_mail.body.encoded
    assert_match CGI::escape(@user.email), @activation_mail.body.encoded
  end

  test "password_reset" do
    assert_equal "Password reset", @reset_mail.subject
    assert_equal [@user.email], @reset_mail.to
    assert_equal ["noreply@example.com"],  @reset_mail.from
    assert_match @user.reset_token,        @reset_mail.body.encoded
    assert_match CGI::escape(@user.email), @reset_mail.body.encoded
  end
end
