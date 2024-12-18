
# Instrucciones para Ejecutar la Aplicación

## Pasos para correr la aplicación desde el inicio:
1. Apagar contenedores activos (si los hay):
   ```bash
   docker-compose down
   ```
2. Construir los contenedores:
   ```bash
   docker-compose build
   ```
3. Iniciar los contenedores:
   ```bash
   docker-compose up
   ```

## Correr el Seed de Compras
   docker exec -it puntos_point-web-1
1. Abrir la consola de Rails:
   ```bash
   rails c
   ```
2. Ejecutar el seed:
   ```ruby
   load "#{Rails.root}/db/seeds/purchases_seeds.rb"
   ```

## Revisar Correos
Accede al visor de correos electrónicos en:
```
http://localhost:1080
```

## Lanzar Manualmente el Daily Report
1. Ejecutar manualmente el worker en la consola de Rails:
   ```ruby
   DailyReportWorker.new.perform
   ```

## Activar `whenever`
1. Actualizar los crontabs para las tareas automatizadas:
   ```bash
   whenever --update-crontab
   ```

## Correr un Job de Sidekiq desde Consola
1. Iniciar el job manualmente:
   ```ruby
   DailyReportWorker.perform_async
   ```

## Pruebas
1. Ejecutar las pruebas con RSpec:
   ```bash
   bundle exec rspec
   ```
