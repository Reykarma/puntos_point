puts "Creando asociaciones entre productos y categorías..."

admin = Admin.first

PaperTrail.request(whodunnit: admin&.id) do
  ProductCategory.create!([
    { product_id: Product.where(name: "Laptop").first.id, category_id: Category.where(name: "Electrónica").first.id },
    { product_id: Product.where(name: "Smartphone").first.id, category_id: Category.where(name: "Electrónica").first.id },
    { product_id: Product.where(name: "Bicicleta").first.id, category_id: Category.where(name: "Deportes").first.id },
    { product_id: Product.where(name: "Sofá").first.id, category_id: Category.where(name: "Hogar").first.id },
    { product_id: Product.where(name: "Drone").first.id, category_id: Category.where(name: "Tecnología").first.id },
    { product_id: Product.where(name: "Libro de ficción").first.id, category_id: Category.where(name: "Libros").first.id },
    { product_id: Product.where(name: "Camisa").first.id, category_id: Category.where(name: "Ropa").first.id },
    { product_id: Product.where(name: "Perfume").first.id, category_id: Category.where(name: "Belleza").first.id },
    { product_id: Product.where(name: "Neumáticos").first.id, category_id: Category.where(name: "Automotriz").first.id },
    { product_id: Product.where(name: "Comida para perros").first.id, category_id: Category.where(name: "Mascotas").first.id },
    { product_id: Product.where(name: "Drone").first.id, category_id: Category.where(name: "Deportes").first.id },
    { product_id: Product.where(name: "Camisa").first.id, category_id: Category.where(name: "Hogar").first.id },
    { product_id: Product.where(name: "Smartphone").first.id, category_id: Category.where(name: "Tecnología").first.id },
    { product_id: Product.where(name: "Libro de ficción").first.id, category_id: Category.where(name: "Hogar").first.id },
    { product_id: Product.where(name: "Laptop").first.id, category_id: Category.where(name: "Tecnología").first.id }
  ])
end

puts "Asociaciones creadas."
