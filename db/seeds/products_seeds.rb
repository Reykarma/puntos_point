# db/seeds/products_seeds.rb
puts "Creando productos..."

def generate_placeholder_image
  base64_image = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
  Tempfile.new(['placeholder', '.png']).tap do |file|
    file.binmode
    file.write(Base64.strict_decode64(base64_image))
    file.rewind
  end
end

admin = Admin.first
if admin.nil?
  puts "⚠️  No hay administradores creados. Por favor crea un admin antes de los productos."
else
  PaperTrail.request(whodunnit: admin.id) do
    products_data = [
      { name: "Laptop", description: "Laptop de alta gama", price: 1500.00, stock: 10 },
      { name: "Smartphone", description: "Teléfono de última generación", price: 800.00, stock: 20 },
      { name: "Bicicleta", description: "Bicicleta de montaña", price: 500.00, stock: 5 },
      { name: "Sofá", description: "Sofá cómodo y moderno", price: 300.00, stock: 3 },
      { name: "Drone", description: "Drone con cámara HD", price: 1200.00, stock: 8 },
      { name: "Libro de ficción", description: "Novela emocionante", price: 20.00, stock: 50 },
      { name: "Camisa", description: "Camisa formal para oficina", price: 30.00, stock: 40 },
      { name: "Perfume", description: "Perfume fragancia exclusiva", price: 100.00, stock: 25 },
      { name: "Neumáticos", description: "Juego de neumáticos todo terreno", price: 600.00, stock: 10 },
      { name: "Comida para perros", description: "Bolsa de alimento premium para perros", price: 50.00, stock: 30 }
    ]

    products_data.each do |data|
      product = Product.new(data.merge(created_by_id: admin.id))
      
      rand(1..3).times do
        placeholder = generate_placeholder_image
        product.images.attach(
          io: placeholder,
          filename: "placeholder_#{SecureRandom.hex(8)}.png",
          content_type: 'image/png'
        )
      end
      
      if product.save
        puts "✅ Producto '#{product.name}' creado con #{product.images.count} imágenes"
      else
        puts "❌ Error creando producto '#{data[:name]}': #{product.errors.full_messages.join(', ')}"
      end
    end
  end
  puts "Productos creados."
end