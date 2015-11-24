# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
AdminUser.create!(email: 'mauriciomdea@gmail.com', password: 'abcd1234', password_confirmation: 'abcd1234')

mma = User.create(name: 'Mauricio Almeida', email: 'mauriciomdea@gmail.com', password: '1234', avatar: 'https://scontent.xx.fbcdn.net/hprofile-xtp1/v/t1.0-1/p50x50/12038035_10153568053793444_3955325592428203406_n.jpg?oh=866157dbf59eb64cb6c746b2acfdc180&oe=56D3406B')
roja = User.create(name: 'Rogério Shimizu', email: 'roja@bunker79.com', password: 'bunker79', avatar: 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xap1/v/t1.0-1/c0.0.50.50/p50x50/10419520_10205423376770262_1580150491982340967_n.jpg')
jane = User.create(name: 'Jane Smith', email: 'jane@example.com', password: '1234')
john = User.create(name: 'John Doe', email: 'john@example.com', password: '1234')

mma.follow(roja)
roja.follow(mma)
jane.follow(mma)
john.follow(mma)

place = Place.create(foursquare_id: '0a0000aa0000000a00aa0001', name: 'Hair Cutters', latitude: -23.5301, longitude: -46.6201)
another_place = Place.create(foursquare_id: '0a0000aa0000000a00aa0002', name: 'Haircut R Us', latitude: -23.5301, longitude: -46.6201)

Post.create(user: jane, category: :haircut, service: 'Female Haircut', image: 'https://igcdn-photos-c-a.akamaihd.net/hphotos-ak-xpf1/t51.2885-15/e15/1516667_585777998223954_1516543266_n.jpg', latitude: -23.53, longitude: -46.62, place: place)
Post.create(user: john, category: :haircut, service: 'Male Haircut', image: 'http://photos-h.ak.instagram.com/hphotos-ak-xfa1/t51.2885-15/s750x750/sh0.08/e35/11374175_112688785756327_281198921_n.jpg', latitude: -23.53, longitude: -46.62, place: place)
Post.create(user: jane, category: :haircut, service: 'My Haircut', image: 'http://photos-b.ak.instagram.com/hphotos-ak-xpf1/t51.2885-15/s640x640/sh0.08/e35/10507820_1520903468224713_366646601_n.jpg', latitude: -23.53, longitude: -46.62)
Post.create(user: john, category: :haircut, service: 'My Haircut', image: 'http://photos-e.ak.instagram.com/hphotos-ak-xaf1/t51.2885-15/e35/12132819_1655918524625908_1185647220_n.jpg', latitude: -23.53, longitude: -46.62)
