require 'spec_helper'

describe User do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean         default(FALSE)
#  address_1       :string(255)
#  address_2       :string(255)
#  town            :string(255)
#  county          :string(255)
#  postcode        :string(255)
#  country         :string(255)
#  phone           :string(255)
#  user_name       :string(255)
#  guest           :boolean         default(FALSE)
#

