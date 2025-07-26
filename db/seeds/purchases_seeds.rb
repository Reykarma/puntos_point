puts "Creando compras aleatorias..."

products = Product.all
clients = Client.all

if products.empty? || clients.empty?
  puts "No hay datos suficientes en las tablas Product o Client. Por favor, agrega datos antes de ejecutar este seed."
else
  num_purchases = 50
  first_purchase_count = 0

  num_purchases.times do
    product = products.sample
    client = clients.sample
    quantity = rand(1..5)
    total_price = product.price * quantity
    purchased_at = Time.current - rand(1..30).days

    created_purchase = Purchase.create!(
      product: product,
      client: client,
      quantity: quantity,
      total_price: total_price,
      purchased_at: purchased_at
    )

    is_first_purchase = product.purchases.count == 1

    if is_first_purchase
      first_purchase_count += 1
      puts "PRIMERA COMPRA: Cliente '#{client.name}' compró el producto '#{product.name}'"
    else
      puts "Compra creada: Cliente '#{client.name}' compró #{quantity} de '#{product.name}' por $#{total_price}."
    end
  end

  puts "\nResumen:"
  puts "Se han creado #{num_purchases} compras en total."
  puts "Se han enviado #{first_purchase_count} correos de primera compra a los administradores." if first_purchase_count > 0
end
