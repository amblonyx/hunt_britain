class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include ApplicationHelper
  include HuntsHelper
end
