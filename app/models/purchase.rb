class Purchase < ApplicationRecord
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :purchased_at, presence: true

  belongs_to :client
  belongs_to :product, touch: true

  after_commit :send_first_purchase_email_if_first, on: :create
    
  private

  def send_first_purchase_email_if_first
    first_id = Purchase.where(product_id: product_id).minimum(:id)
    return unless first_id == id
    
    PurchaseMailer.first_purchase_email(product, client).deliver_later
  end

end
