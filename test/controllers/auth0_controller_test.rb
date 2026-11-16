require 'test_helper'

class Auth0ControllerTest < ActionDispatch::IntegrationTest
  UID = 'auth0|123'

  setup do
    OmniAuth.config.test_mode = true
    @user = User.create!(first_name: 'Pat', last_name: 'Roller',
                         email: 'pat@example.com')
  end

  teardown do
    OmniAuth.config.mock_auth[:auth0] = nil
    OmniAuth.config.test_mode = false
  end

  test 'a verified Auth0 login is linked to the user with its email' do
    log_in(email_verified: true)

    identity = Identity.find_by!(auth0_uid: UID)
    assert identity.email_verified
    assert_equal @user, identity.user
    assert_equal identity.id, session[:identity_id]
    assert_redirected_to commitments_path
  end

  test 'an unverified Auth0 login is not linked to the user with its email' do
    log_in(email_verified: false)

    identity = Identity.find_by!(auth0_uid: UID)
    assert_not identity.email_verified
    assert_nil identity.user
    assert_redirected_to root_url
  end

  test 'verification is picked up from Auth0 at the next login' do
    log_in(email_verified: false)
    log_in(email_verified: true)

    identity = Identity.find_by!(auth0_uid: UID)
    assert identity.email_verified
    assert_equal @user, identity.user
    assert_redirected_to commitments_path
  end

  test 'a verified flag that Auth0 does not confirm is withdrawn at login' do
    identity = Identity.create!(auth0_uid: UID, email: @user.email,
                                email_verified: true)

    log_in(email_verified: false)

    assert_not identity.reload.email_verified
    assert_nil identity.user
    assert_redirected_to root_url
  end

  test 'the email verification redirect changes nothing and signs nobody in' do
    identity = Identity.create!(auth0_uid: UID, email: @user.email,
                                email_verified: false)

    get '/auth/auth0/verify_email',
        params: { success: 'true', email: @user.email }

    assert_redirected_to root_url
    assert_nil session[:identity_id]
    assert_not identity.reload.email_verified
    assert_nil identity.user
  end

  test 'a failed email verification redirect reports the failure' do
    get '/auth/auth0/verify_email',
        params: { success: 'false', message: 'This URL can be used only once' }

    assert_redirected_to root_url
    assert_equal 'Email verification failed – this URL can be used only once',
                 flash[:alert]
  end

  private

  def log_in(email_verified:)
    OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new(
      provider: 'auth0',
      uid: UID,
      info: { first_name: 'Pat', last_name: 'Roller', email: @user.email },
      extra: { raw_info: { email_verified: email_verified } }
    )

    get '/auth/auth0/callback'
  end
end
