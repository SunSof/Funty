class User < ApplicationRecord
  authenticates_with_sorcery!
  before_create :generate_token, :top_up_balance
  before_validation :email_downcase

  validates :password, length: { minimum: 6 }, if: lambda {
                                                     new_record? || changes[:crypted_password]
                                                   }
  validates :password, confirmation: true, if: lambda {
                                                 new_record? || changes[:crypted_password]
                                               }
  validates :password_confirmation, presence: true, if: lambda {
                                                          new_record? || changes[:crypted_password]
                                                        }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i
  validates(:email, presence: true, length: { maximum: 30 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true)

  validates :name, presence: true, length: { minimum: 2, maximum: 20 }

  private

  def generate_token
    self.token ||= rand(1_000_000...10_000_000)
  end

  def email_downcase
    self.email = email.downcase
  end

  def top_up_balance
    self.balance = 15000
  end
end
