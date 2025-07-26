set :output, "log/cron.log"

every 1.day, at: '00:00 am' do
  # Llamamos al worker de Sidekiq de forma asíncrona
  runner "DailyReportWorker.perform_async"
end

