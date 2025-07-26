class Admin < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "is not a valid email" }
  validates :password, presence: true, on: :create

  has_many :products, foreign_key: :created_by_id, dependent: :nullify
  has_many :categories, foreign_key: :created_by_id, dependent: :nullify

  before_validation :downcase_email

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
