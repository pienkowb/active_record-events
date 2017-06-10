class User < ActiveRecord::Base
  has_event :confirm, object: :email
end
