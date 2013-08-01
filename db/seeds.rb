# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.create(
	name: 'Mr Admin', 
	email: 'shortclaws@gmail.com', 
	password: 'treasure', 
	password_confirmation: 'treasure',
	user_name: 'shortclaws@gmail.com'
)
admin.toggle!(:admin)
	
locations = Location.create([
	{ name: 'Bath', description: 'Bath City', image: 'BathMain.JPG', region: 'South West', hunt_mode: 'Walking', data_file: 'bath' },
	{ name: 'Brighton', description: 'Brighton City', image: 'BrightonMain.JPG', region: 'South East', hunt_mode: 'Walking', data_file: 'brighton' },
	{ name: 'Bristol', description: 'Bristol City', image: 'BristolMain.JPG', region: 'South West', hunt_mode: 'Walking', data_file: 'bristol' },
	{ name: 'Bruton', description: 'Around Bruton, Somerset', image: 'BrutonMain.JPG', region: 'South West', hunt_mode: 'Driving', data_file: 'bruton' },
	{ name: 'City of London', description: 'The City of London', image: 'CityMain.JPG', region: 'London', hunt_mode: 'Walking', data_file: 'londoncity' },
	{ name: 'Ludlow', description: 'Ludlow Town', image: 'LudlowMain.JPG', region: 'West Midlands', hunt_mode: 'Walking', data_file: 'ludlow' },
	{ name: 'Oxford', description: 'Oxford City', image: 'OxfordMain.JPG', region: 'South East', hunt_mode: 'Walking', data_file: 'oxford' },
	{ name: 'Richmond', description: 'Richmond-upon-Thames', image: 'RichmondMain.JPG', region: 'London', hunt_mode: 'Walking', data_file: 'richmond' },
	{ name: 'Southwark', description: 'Southwark', image: 'SouthwarkMain.JPG', region: 'London', hunt_mode: 'Walking', data_file: 'southwark' },
	{ name: 'Stratford', description: 'Stratford-upon-Avon', image: 'StratfordMain.JPG', region: 'West Midlands', hunt_mode: 'Walking', data_file: 'stratford' },
	{ name: 'Windsor and Eton', description: 'Windsor and Eton', image: 'WindsorMain.JPG', region: 'South East', hunt_mode: 'Walking', data_file: 'windsor' }
])

location = Location.find_by_name('Bath')
location.products.create(  product_code: 'Bath-Easy-O', name: 'Bath (easy version), for phones and tablets', format: 'Online', price: '9.00', data_file: 'bath-easy', dormant: false )
location.products.create(  product_code: 'Bath-Easy-D', name: 'Bath (easy version), PDF download', format: 'Download', price: '9.00', data_file: 'THB Bath Easy Treasure Hunt.pdf', data_file_2: 'THB Bath Easy Cheat Sheet.pdf', dormant: false )
location.products.create(  product_code: 'Bath-Easy-P', name: 'Bath (easy version), posted to you', format: 'Paper', price: '10.00', dormant: false )

location.products.create(  product_code: 'Bath-Hard-O', name: 'Bath (hard version), for phones and tablets', format: 'Online', price: '9.00', data_file: 'bath-hard', dormant: false )
location.products.create(  product_code: 'Bath-Hard-D', name: 'Bath (hard version), PDF download', format: 'Download', price: '9.00', data_file: 'THB Bath Hard Treasure Hunt.pdf', data_file_2: 'THB Bath Hard Cheat Sheet.pdf', dormant: false )
location.products.create(  product_code: 'Bath-Hard-P', name: 'Bath (hard version), posted to you', format: 'Paper', price: '10.00', dormant: false )

location = Location.find_by_name('Brighton')
location.products.create(  product_code: 'Brighton-Easy-O', name: 'Brighton, for phones and tablets', format: 'Online', price: '9.00', data_file: 'brighton-easy', dormant: false )
location.products.create(  product_code: 'Brighton-Easy-D', name: 'Brighton, PDF download', format: 'Download', price: '9.00', data_file: 'THB Brighton Treasure Hunt.pdf', data_file_2: 'THB Brighton Cheat Sheet.pdf', dormant: false )
location.products.create(  product_code: 'Brighton-Easy-P', name: 'Brighton, posted to you', format: 'Paper', price: '10.00', dormant: false )

location = Location.find_by_name('Bristol')
location.products.create(  product_code: 'Bristol-Easy-O', name: 'Bristol, for phones and tablets', format: 'Online', price: '9.00', data_file: 'bristol-easy', dormant: false )
location.products.create(  product_code: 'Bristol-Easy-D', name: 'Bristol, PDF download', format: 'Download', price: '9.00', data_file: 'THB Bristol Treasure Hunt.pdf', data_file_2: 'THB Bristol Cheat Sheet.pdf', dormant: false )
location.products.create(  product_code: 'Bristol-Easy-P', name: 'Bristol, posted to you', format: 'Paper', price: '10.00', dormant: false )

location = Location.find_by_name('Bruton')
location.products.create(  product_code: 'Bruton-Easy-O', name: 'Bruton, for phones and tablets', format: 'Online', price: '9.00', data_file: 'bruton-easy', dormant: true )
location.products.create(  product_code: 'Bruton-Easy-D', name: 'Bruton, PDF download', format: 'Download', price: '9.00', data_file: 'THB Bruton Treasure Hunt.pdf', data_file_2: 'THB Bruton Cheat Sheet.pdf', dormant: true )
location.products.create(  product_code: 'Bruton-Easy-P', name: 'Bruton, posted to you', format: 'Paper', price: '10.00', dormant: true )

location = Location.find_by_name('City of London')
location.products.create(  product_code: 'City-Easy-O', name: 'City, for phones and tablets', format: 'Online', price: '9.00', data_file: 'city-easy', dormant: false )
location.products.create(  product_code: 'City-Easy-D', name: 'City, PDF download', format: 'Download', price: '9.00', data_file: 'THB City of London Treasure Hunt.pdf', data_file_2: 'THB City of London Cheat Sheet.pdf', dormant: false )
location.products.create(  product_code: 'City-Easy-P', name: 'City, posted to you', format: 'Paper', price: '10.00', dormant: false )

location = Location.find_by_name('Ludlow')
location.products.create(  product_code: 'Ludlow-Easy-O', name: 'Ludlow (easy version), for phones and tablets', format: 'Online', price: '9.00', data_file: 'ludlow-easy', dormant: false )
location.products.create(  product_code: 'Ludlow-Easy-D', name: 'Ludlow (easy version), PDF download', format: 'Download', data_file: 'THB Ludlow Easy Treasure Hunt.pdf', data_file_2: 'THB Ludlow Easy Cheat Sheet.pdf', price: '9.00', dormant: false )
location.products.create(  product_code: 'Ludlow-Easy-P', name: 'Ludlow (easy version), posted to you', format: 'Paper', price: '10.00', dormant: false )

location.products.create(  product_code: 'Ludlow-Hard-O', name: 'Ludlow (hard version), for phones and tablets', format: 'Online', price: '9.00', data_file: 'ludlow-hard', dormant: true )
location.products.create(  product_code: 'Ludlow-Hard-D', name: 'Ludlow (hard version), PDF download', format: 'Download', data_file: 'THB Ludlow Hard Treasure Hunt.pdf', data_file_2: 'THB Ludlow Hard Cheat Sheet.pdf', price: '9.00', dormant: true )
location.products.create(  product_code: 'Ludlow-Hard-P', name: 'Ludlow (hard version), posted to you', format: 'Paper', price: '10.00', dormant: true )

location = Location.find_by_name('Oxford')
location.products.create(  product_code: 'Oxford-Easy-O', name: 'Oxford, for phones and tablets', format: 'Online', price: '9.00', data_file: 'oxford-easy', dormant: false )
location.products.create(  product_code: 'Oxford-Easy-D', name: 'Oxford, PDF download', format: 'Download', price: '9.00', data_file: 'THB Oxford Treasure Hunt.pdf', data_file_2: 'THB Oxford Cheat Sheet.pdf', dormant: false )
location.products.create(  product_code: 'Oxford-Easy-P', name: 'Oxford, posted to you', format: 'Paper', price: '10.00', dormant: false )

location = Location.find_by_name('Richmond')
location.products.create(  product_code: 'Richmond-Easy-O', name: 'Richmond (easy version), for phones and tablets', format: 'Online', price: '9.00', data_file: 'richmond-easy', dormant: false )
location.products.create(  product_code: 'Richmond-Easy-D', name: 'Richmond (easy version), PDF download', format: 'Download', price: '9.00', data_file: 'THB Richmond Treasure Hunt.pdf', data_file_2: 'THB Richmond Cheat Sheet.pdf', dormant: false )
location.products.create(  product_code: 'Richmond-Easy-P', name: 'Richmond (easy version), posted to you', format: 'Paper', price: '10.00', dormant: false )

location.products.create(  product_code: 'Richmond-Hard-O', name: 'Richmond (hard version), for phones and tablets', format: 'Online', price: '9.00', data_file: 'richmond-hard', dormant: true )
location.products.create(  product_code: 'Richmond-Hard-D', name: 'Richmond (hard version), PDF download', format: 'Download', price: '9.00', data_file: 'THB Richmond Hard Treasure Hunt.pdf', data_file_2: 'THB Richmond Hard Cheat Sheet.pdf', dormant: true )
location.products.create(  product_code: 'Richmond-Hard-P', name: 'Richmond (hard version), posted to you', format: 'Paper', price: '10.00', dormant: true )

location = Location.find_by_name('Southwark')
location.products.create(  product_code: 'Southwark-Easy-O', name: 'Southwark, for phones and tablets', format: 'Online', price: '9.00', data_file: 'southwark-easy', dormant: false )
location.products.create(  product_code: 'Southwark-Easy-D', name: 'Southwark, PDF download', format: 'Download', price: '9.00', data_file: 'THB Southwark Treasure Hunt.pdf', data_file_2: 'THB Southwark Cheat Sheet.pdf', dormant: false )
location.products.create(  product_code: 'Southwark-Easy-P', name: 'Southwark, posted to you', format: 'Paper', price: '10.00', dormant: false )

location = Location.find_by_name('Stratford')
location.products.create(  product_code: 'Stratford-Easy-O', name: 'Stratford (easy version), for phones and tablets', format: 'Online', price: '9.00', data_file: 'stratford-easy', dormant: false )
location.products.create(  product_code: 'Stratford-Easy-D', name: 'Stratford (easy version), PDF download', format: 'Download', price: '9.00', data_file: 'THB Stratford Treasure Hunt.pdf', data_file_2: 'THB Stratford Cheat Sheet.pdf', dormant: false )
location.products.create(  product_code: 'Stratford-Easy-P', name: 'Stratford (easy version), posted to you', format: 'Paper', price: '10.00', dormant: false )

location.products.create(  product_code: 'Stratford-Hard-O', name: 'Stratford (hard version), for phones and tablets', format: 'Online', price: '9.00', data_file: 'stratford-hard', dormant: true )
location.products.create(  product_code: 'Stratford-Hard-D', name: 'Stratford (hard version), PDF download', format: 'Download', price: '9.00', data_file: 'THB Stratford Hard Treasure Hunt.pdf', data_file_2: 'THB Stratford Hard Cheat Sheet.pdf', dormant: true )
location.products.create(  product_code: 'Stratford-Hard-P', name: 'Stratford (hard version), posted to you', format: 'Paper', price: '10.00', dormant: true )

location = Location.find_by_name('Windsor and Eton')
location.products.create(  product_code: 'Windsor-Easy-O', name: 'Windsor, for phones and tablets', format: 'Online', price: '9.00', data_file: 'windsor-easy', dormant: false )
location.products.create(  product_code: 'Windsor-Easy-D', name: 'Windsor, PDF download', format: 'Download', price: '9.00', data_file: 'THB Windsor Treasure Hunt.pdf', data_file_2: 'THB Windsor Cheat Sheet.pdf', dormant: false )
location.products.create(  product_code: 'Windsor-Easy-P', name: 'Windsor, posted to you', format: 'Paper', price: '10.00', dormant: false )
