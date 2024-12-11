class DailyReportMailer < ActionMailer::Base
  default from: 'test@puntospoint.com'

  def daily_report_email(admin, purchases, csv_data)
    @admin = admin
    @purchases = purchases

    attachments['daily_purchases.csv'] = {
      mime_type: 'text/csv',
      content: csv_data
    }

    mail(
      to: @admin.email,
      subject: 'Reporte diario de compras'
    )
  end
end
