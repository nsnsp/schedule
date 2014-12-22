class Identity < ActiveRecord::Base
  has_paper_trail

  belongs_to :user, inverse_of: :identities

  validates :auth0_uid, uniqueness: true

  def provider_is?(provider)
    auth0_uid.split('|').first == provider.downcase
  end

  def email_trusted?
    # explicitly verified Auth0 account, or any other account (implicitly
    # trust email addresses from other providers like Gmail, Facebook, Yahoo)
    email_verified || !provider_is?('auth0')
  end

  def self.find_by_auth0_email(email)
    where(email: email).where('auth0_uid LIKE ?', 'auth0|%').first
  end
end
