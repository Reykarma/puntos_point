require 'csv'

class DailyReportWorker
  include Sidekiq::Worker

  def perform
    admins = Admin.all
    purchases = Purchase.order('purchased_at DESC')
    #purchases = Purchase.where(purchased_at: Time.now.beginning_of_day - 1.day..Time.now.end_of_day - 1.day).order('purchased_at DESC')

    csv_data = CSV.generate do |csv|
      # Cabecera
      csv << ["ID", "Product Name", "Client Name", "Quantity", "Total Price", "Purchased At"]
      # Filas con datos
      purchases.each do |purchase|
        csv << [
          purchase.id,
          purchase.product.name,
          purchase.client.name,
          purchase.quantity,
          purchase.total_price,
          purchase.purchased_at.strftime("%d-%m-%Y")

        ]
      end
    end

    admins.each do |admin|
      DailyReportMailer.daily_report_email(admin, purchases, csv_data).deliver
    end
  end
end
