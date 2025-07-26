class DailyReportMailer < ApplicationMailer
  default from: 'test@puntospoint.com'

  def daily_report_email(admin, csv_data)
    @admin = admin

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
