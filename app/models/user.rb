class User < ActiveRecord::Base
  include Nameable
  include RoleModel

  # do not reorder this array (only add new members to the end)
  roles :admin, :national, :user_manager, :paid_staff

  has_paper_trail

  has_many :commitments, inverse_of: :user, dependent: :restrict_with_error
  has_many :identities, inverse_of: :user, dependent: :destroy

  validate :unique_name
  validates :first_name, :last_name, presence: true
  validates :phone, format: { with: /\A\D*(?:\d\D*){10}\z/ }, allow_nil: true
  validates :email, uniqueness: true, format: {
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  }

  scope :active, -> { where(suspended: false) }
  scope :suspended, -> { where(suspended: true) }

  strip_attributes collapse_spaces: true
  strip_attributes only: [:phone], regex: /\D/

  alias_method :to_s, :name

  def image_url
    all = identities.map { |identity| identity.image_url }.compact
    desirable = all.reject { |url| URI(url).path.include?('silhouette') }
    desirable.first || all.first
  end

  private

  def unique_name
    errors[:base] << "A user named #{name} already exists." if self.class.
      where(first_name: first_name, last_name: last_name).
      where.not(id: id).exists?
  end
end
