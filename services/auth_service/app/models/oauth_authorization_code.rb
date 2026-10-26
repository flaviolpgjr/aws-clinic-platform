class OauthAuthorizationCode < ApplicationRecord
  belongs_to :user

  CODE_EXPIRATION = 60.seconds

  validates :client_id, presence: true
  validates :code_digest, presence: true, uniqueness: true
  validates :redirect_uri, presence: true
  validates :code_challenge, presence: true
  validates :expires_at, presence: true

  def self.issue!(user:, client_id:, redirect_uri:, code_challenge:)
    code = SecureRandom.urlsafe_base64(32)

    create!(
      user: user,
      client_id: client_id,
      redirect_uri: redirect_uri,
      code_challenge: code_challenge,
      code_digest: Digest::SHA256.hexdigest(code),
      expires_at: CODE_EXPIRATION.from_now
    )

    code
  end

  def expired?
    expires_at <= Time.current
  end

  def used?
    used_at.present?
  end

  def usable?
    !expired? && !used?
  end
end