class Identity < ApplicationRecord
  include Nameable

  has_paper_trail

  belongs_to :user, inverse_of: :identities, optional: true

  validates :auth0_uid, uniqueness: true

  def provider
    auth0_uid.split('|').first.capitalize
  end

  def provider_is?(provider)
    provider.to_s.downcase == self.provider.downcase
  end

  def email_trusted?
    # explicitly verified Auth0 account, or any other account (implicitly
    # trust email addresses from other providers like Gmail, Facebook, Yahoo)
    email_verified || !provider_is?('auth0')
  end

  def image_url
    if provider_is?('facebook')
      id = auth0_uid.split('|').last
      # 512x512 just because that's what Google gives us
      "https://graph.facebook.com/#{id}/picture?width=512&height=512"
    else
      super
    end
  end

  def self.find_by_auth0_email(email)
    where(email: email).where('auth0_uid LIKE ?', 'auth0|%').first
  end
end
