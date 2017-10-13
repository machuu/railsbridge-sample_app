class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  before_save   :downcase_email
  before_create :create_activation_digest

  validates :name,  presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Returns the hash for the given password
  def User.digest(password_string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST
                                                : BCrypt::Engine.cost
    BCrypt::Password.create(password_string, cost: cost)
  end

  # Return a random Token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remember current token
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Activate user
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Send Activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Check if given token matches the digest
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgt user by clearing `remember_digest`
  def forget
    update_attribute(:remember_digest, nil)
  end

  private

    def downcase_email
      email.downcase!
    end

    def create_activation_digest
      self.activation_token   = User.new_token
      self.activation_digest  = User.digest(activation_token)
    end
end
