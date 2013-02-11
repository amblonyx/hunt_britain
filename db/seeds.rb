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
