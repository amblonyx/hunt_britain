require 'spec_helper'

describe Hunt do
  pending "add some examples to (or delete) #{__FILE__}"
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

