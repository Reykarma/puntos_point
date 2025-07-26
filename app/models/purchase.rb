class Purchase < ApplicationRecord
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :purchased_at, presence: true

  belongs_to :client
  belongs_to :product

  after_create :send_first_purchase_email, if: :first_purchase?

  private

  def first_purchase?
    product.purchases.count == 1
  end

  def send_first_purchase_email
    PurchaseMailer.first_purchase_email(product, client).deliver_later
  end
end
