# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

User.create(name: 'Mauricio Almeida', email: 'mauriciomdea@gmail.com', password: '1234')
User.create(name: 'Rogério Shimizu', email: 'roja@bunker79.com', password: 'bunker79')
User.create(name: 'Jane Smith', email: 'jane@example.com', password: '1234')
User.create(name: 'John Doe', email: 'john@example.com', password: '1234')

# Category.create(name: 'haircut')
# Category.create(name: 'hairstyle')
# Category.create(name: 'colouring')
# Category.create(name: 'highlights')
# Category.create(name: 'nails')
# Category.create(name: 'makeup')
