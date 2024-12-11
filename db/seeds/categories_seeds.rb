# encoding: UTF-8

puts "Creando categorías..."

categories = Category.create!([
  { name: "Electrónica", description: "Productos electrónicos", created_by_id: Admin.first.id },
  { name: "Hogar", description: "Artículos para el hogar", created_by_id: Admin.first.id },
  { name: "Deportes", description: "Accesorios deportivos", created_by_id: Admin.first.id },
  { name: "Juguetes", description: "Juguetes para niños", created_by_id: Admin.first.id },
  { name: "Libros", description: "Libros y material de lectura", created_by_id: Admin.first.id },
  { name: "Ropa", description: "Ropa y accesorios", created_by_id: Admin.first.id },
  { name: "Belleza", description: "Productos de cuidado personal", created_by_id: Admin.first.id },
  { name: "Tecnología", description: "Dispositivos tecnológicos avanzados", created_by_id: Admin.first.id },
  { name: "Automotriz", description: "Accesorios para automóviles", created_by_id: Admin.first.id },
  { name: "Mascotas", description: "Productos para mascotas", created_by_id: Admin.first.id }
])

puts "Categorías creadas."
