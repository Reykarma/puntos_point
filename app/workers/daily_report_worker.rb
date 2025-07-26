require 'csv'

class DailyReportWorker
  include Sidekiq::Worker

  def perform
    admins = Admin.all
    start_time = 1.day.ago.beginning_of_day
    end_time = 1.day.ago.end_of_day
    purchases = Purchase.where(purchased_at: start_time..end_time).order(purchased_at: :desc)

    csv_data = CSV.generate do |csv|
      csv << ["ID", "Product Name", "Client Name", "Quantity", "Total Price", "Purchased At"]
      purchases.each do |purchase|
        csv << [
          purchase.id,
          purchase.product.name,
          purchase.client.name,
          purchase.quantity,
          purchase.total_price,
          purchase.purchased_at.strftime("%d-%m-%Y %H:%M")
        ]
      end
    end

    admins.each do |admin|
      DailyReportMailer.daily_report_email(admin, csv_data).deliver_later
    end
  end
end
