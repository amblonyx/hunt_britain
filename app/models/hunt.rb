class Hunt < ActiveRecord::Base
  attr_accessible :completed, :current_clue, :current_status, :email, :last_submitted, 
	:paused, :product_id, :user_id, :started, :started_at, :team_name, :time_taken, :voucher_code
  
  belongs_to :product
  belongs_to :user
end
# == Schema Information
#
# Table name: hunts
#
#  id             :integer         not null, primary key
#  product_id     :integer
#  voucher_code   :string(255)
#  team_name      :string(255)
#  email          :string(255)
#  started        :boolean
#  paused         :boolean
#  completed      :boolean
#  started_at     :datetime
#  last_submitted :datetime
#  current_clue   :integer
#  current_status :string(255)
#  time_taken     :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  user_id        :integer
#

