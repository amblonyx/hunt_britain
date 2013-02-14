class Hunt < ActiveRecord::Base
  attr_accessible :completed, :current_clue, :current_status, :email, :last_submitted, 
	:paused, :product_id, :user_id, :started, :started_at, :team_name, :time_taken, :voucher_code
  
  belongs_to :product
  belongs_to :user
end
