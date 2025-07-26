# Ejecutar seeds individuales
puts "Ejecutando seeds..."

load Rails.root.join('db/seeds/admin_and_clients_seeds.rb')
load Rails.root.join('db/seeds/categories_seeds.rb')
load Rails.root.join('db/seeds/products_seeds.rb')
load Rails.root.join('db/seeds/products_categories_seeds.rb')

puts "Se han ejecutado todos los seeds."
