class Location < ActiveRecord::Base
  attr_accessible :description, :hunt_mode, :image, :name, :region, :data_file
  	has_many :products, dependent: :destroy

end
