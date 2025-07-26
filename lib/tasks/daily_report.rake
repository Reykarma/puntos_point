namespace :daily_report do
  desc 'Enviar el reporte diario de compras'
  task send: :environment do
    DailyReportWorker.perform_async
  end
end
