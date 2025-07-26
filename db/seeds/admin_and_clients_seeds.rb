puts "Creando administradores..."
Admin.create!([
  { name: "Admin1", email: "admin1@example.com", password: "password123", password_confirmation: "password123" },
  { name: "Admin2", email: "admin2@example.com", password: "password123", password_confirmation: "password123" }
])
puts "Administradores creados."

puts "Creando clientes..."
Client.create!([
  { name: "Cliente1", email: "cliente1@example.com", password: "password123", password_confirmation: "password123" },
  { name: "Cliente2", email: "cliente2@example.com", password: "password123", password_confirmation: "password123" }
])
puts "Clientes creados."
