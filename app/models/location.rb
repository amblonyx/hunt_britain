class Location < ActiveRecord::Base
  attr_accessible :description, :hunt_mode, :image, :name, :region, :data_file
  	has_many :products, dependent: :destroy

end
# == Schema Information
#
# Table name: locations
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(255)
#  hunt_mode   :string(255)
#  image       :string(255)
#  region      :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  data_file   :string(255)
#

