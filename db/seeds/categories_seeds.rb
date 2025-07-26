puts "Creando categorías..."

admin = Admin.first

PaperTrail.request(whodunnit: admin.id) do
  categories = Category.create!([
    { name: "Electrónica", description: "Productos electrónicos", created_by_id: admin.id },
    { name: "Hogar", description: "Artículos para el hogar", created_by_id: admin.id },
    { name: "Deportes", description: "Accesorios deportivos", created_by_id: admin.id },
    { name: "Juguetes", description: "Juguetes para niños", created_by_id: admin.id },
    { name: "Libros", description: "Libros y material de lectura", created_by_id: admin.id },
    { name: "Ropa", description: "Ropa y accesorios", created_by_id: admin.id },
    { name: "Belleza", description: "Productos de cuidado personal", created_by_id: admin.id },
    { name: "Tecnología", description: "Dispositivos tecnológicos avanzados", created_by_id: admin.id },
    { name: "Automotriz", description: "Accesorios para automóviles", created_by_id: admin.id },
    { name: "Mascotas", description: "Productos para mascotas", created_by_id: admin.id }
  ])
end

puts "Categorías creadas."
