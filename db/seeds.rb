# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

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
location.products.create(  product_code: 'Bath-Easy-O', name: 'Bath (easy version), for phones and tablets', format: 'Online', price: '399', data_file: 'bath-easy' )
location.products.create(  product_code: 'Bath-Easy-D', name: 'Bath (easy version), PDF download', format: 'Download', price: '399' )
location.products.create(  product_code: 'Bath-Easy-P', name: 'Bath (easy version), posted to you', format: 'Paper', price: '499' )
location.products.create(  product_code: 'Bath-Hard-O', name: 'Bath (hard version), for phones and tablets', format: 'Online', price: '399', data_file: 'bath-hard' )
location.products.create(  product_code: 'Bath-Hard-D', name: 'Bath (hard version), PDF download', format: 'Download', price: '399' )
location.products.create(  product_code: 'Bath-Hard-P', name: 'Bath (hard version), posted to you', format: 'Paper', price: '499' )

location = Location.find_by_name('Bristol')
location.products.create(  product_code: 'Bristol-Easy-O', name: 'Bristol, for phones and tablets', format: 'Online', price: '399', data_file: 'bristol-easy' )
location.products.create(  product_code: 'Bristol-Easy-D', name: 'Bristol, PDF download', format: 'Download', price: '399' )
location.products.create(  product_code: 'Bristol-Easy-P', name: 'Bristol, posted to you', format: 'Paper', price: '499' )

location = Location.find_by_name('Brighton')
location.products.create(  product_code: 'Brighton-Easy-O', name: 'Brighton, for phones and tablets', format: 'Online', price: '399', data_file: 'brighton-easy' )
location.products.create(  product_code: 'Brighton-Easy-D', name: 'Brighton, PDF download', format: 'Download', price: '399' )
location.products.create(  product_code: 'Brighton-Easy-P', name: 'Brighton, posted to you', format: 'Paper', price: '499' )

location = Location.find_by_name('Bruton')
location.products.create(  product_code: 'Bruton-Easy-O', name: 'Bruton, for phones and tablets', format: 'Online', price: '399', data_file: 'bruton-easy' )
location.products.create(  product_code: 'Bruton-Easy-D', name: 'Bruton, PDF download', format: 'Download', price: '399' )
location.products.create(  product_code: 'Bruton-Easy-P', name: 'Bruton, posted to you', format: 'Paper', price: '499' )

location = Location.find_by_name('City of London')
location.products.create(  product_code: 'City-Easy-O', name: 'City, for phones and tablets', format: 'Online', price: '399', data_file: 'city-easy' )
location.products.create(  product_code: 'City-Easy-D', name: 'City, PDF download', format: 'Download', price: '399' )
location.products.create(  product_code: 'City-Easy-P', name: 'City, posted to you', format: 'Paper', price: '499' )

location = Location.find_by_name('Ludlow')
location.products.create(  product_code: 'Ludlow-Easy-O', name: 'Ludlow (easy version), for phones and tablets', format: 'Online', price: '399', data_file: 'ludlow-easy' )
location.products.create(  product_code: 'Ludlow-Easy-D', name: 'Ludlow (easy version), PDF download', format: 'Download', price: '399' )
location.products.create(  product_code: 'Ludlow-Easy-P', name: 'Ludlow (easy version), posted to you', format: 'Paper', price: '499' )
location.products.create(  product_code: 'Ludlow-Hard-O', name: 'Ludlow (hard version), for phones and tablets', format: 'Online', price: '399', data_file: 'ludlow-hard' )
location.products.create(  product_code: 'Ludlow-Hard-D', name: 'Ludlow (hard version), PDF download', format: 'Download', price: '399' )
location.products.create(  product_code: 'Ludlow-Hard-P', name: 'Ludlow (hard version), posted to you', format: 'Paper', price: '499' )

location = Location.find_by_name('Oxford')
location.products.create(  product_code: 'Oxford-Easy-O', name: 'Oxford, for phones and tablets', format: 'Online', price: '399', data_file: 'oxford-easy' )
location.products.create(  product_code: 'Oxford-Easy-D', name: 'Oxford, PDF download', format: 'Download', price: '399' )
location.products.create(  product_code: 'Oxford-Easy-P', name: 'Oxford, posted to you', format: 'Paper', price: '499' )

location = Location.find_by_name('Richmond')
location.products.create(  product_code: 'Richmond-Easy-O', name: 'Richmond (easy version), for phones and tablets', format: 'Online', price: '399', data_file: 'richmond-easy' )
location.products.create(  product_code: 'Richmond-Easy-D', name: 'Richmond (easy version), PDF download', format: 'Download', price: '399' )
location.products.create(  product_code: 'Richmond-Easy-P', name: 'Richmond (easy version), posted to you', format: 'Paper', price: '499' )
location.products.create(  product_code: 'Richmond-Hard-O', name: 'Richmond (hard version), for phones and tablets', format: 'Online', price: '399', data_file: 'richmond-hard' )
location.products.create(  product_code: 'Richmond-Hard-D', name: 'Richmond (hard version), PDF download', format: 'Download', price: '399' )
location.products.create(  product_code: 'Richmond-Hard-P', name: 'Richmond (hard version), posted to you', format: 'Paper', price: '499' )

location = Location.find_by_name('Southwark')
location.products.create(  product_code: 'Southwark-Easy-O', name: 'Southwark, for phones and tablets', format: 'Online', price: '399', data_file: 'southwark-easy' )
location.products.create(  product_code: 'Southwark-Easy-D', name: 'Southwark, PDF download', format: 'Download', price: '399' )
location.products.create(  product_code: 'Southwark-Easy-P', name: 'Southwark, posted to you', format: 'Paper', price: '499' )

location = Location.find_by_name('Stratford')
location.products.create(  product_code: 'Stratford-Easy-O', name: 'Stratford (easy version), for phones and tablets', format: 'Online', price: '399', data_file: 'stratford-easy' )
location.products.create(  product_code: 'Stratford-Easy-D', name: 'Stratford (easy version), PDF download', format: 'Download', price: '399' )
location.products.create(  product_code: 'Stratford-Easy-P', name: 'Stratford (easy version), posted to you', format: 'Paper', price: '499' )
location.products.create(  product_code: 'Stratford-Hard-O', name: 'Stratford (hard version), for phones and tablets', format: 'Online', price: '399', data_file: 'stratford-hard' )
location.products.create(  product_code: 'Stratford-Hard-D', name: 'Stratford (hard version), PDF download', format: 'Download', price: '399' )
location.products.create(  product_code: 'Stratford-Hard-P', name: 'Stratford (hard version), posted to you', format: 'Paper', price: '499' )

location = Location.find_by_name('Windsor and Eton')
location.products.create(  product_code: 'Windsor-Easy-O', name: 'Windsor, for phones and tablets', format: 'Online', price: '399', data_file: 'windsor-easy' )
location.products.create(  product_code: 'Windsor-Easy-D', name: 'Windsor, PDF download', format: 'Download', price: '399' )
location.products.create(  product_code: 'Windsor-Easy-P', name: 'Windsor, posted to you', format: 'Paper', price: '499' )
