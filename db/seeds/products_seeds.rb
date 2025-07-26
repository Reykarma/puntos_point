puts "Creando productos..."

admin = Admin.first
if admin.nil?
  puts "⚠️  No hay administradores creados. Por favor crea un admin antes de los productos."
else
  PaperTrail.request(whodunnit: admin.id) do
    products = Product.create!([
      { name: "Laptop", description: "Laptop de alta gama", price: 1500.00, stock: 10, created_by_id: admin.id },
      { name: "Smartphone", description: "Teléfono de última generación", price: 800.00, stock: 20, created_by_id: admin.id },
      { name: "Bicicleta", description: "Bicicleta de montaña", price: 500.00, stock: 5, created_by_id: admin.id },
      { name: "Sofá", description: "Sofá cómodo y moderno", price: 300.00, stock: 3, created_by_id: admin.id },
      { name: "Drone", description: "Drone con cámara HD", price: 1200.00, stock: 8, created_by_id: admin.id },
      { name: "Libro de ficción", description: "Novela emocionante", price: 20.00, stock: 50, created_by_id: admin.id },
      { name: "Camisa", description: "Camisa formal para oficina", price: 30.00, stock: 40, created_by_id: admin.id },
      { name: "Perfume", description: "Perfume fragancia exclusiva", price: 100.00, stock: 25, created_by_id: admin.id },
      { name: "Neumáticos", description: "Juego de neumáticos todo terreno", price: 600.00, stock: 10, created_by_id: admin.id },
      { name: "Comida para perros", description: "Bolsa de alimento premium para perros", price: 50.00, stock: 30, created_by_id: admin.id }
    ])
  end
  puts "Productos creados."
end
