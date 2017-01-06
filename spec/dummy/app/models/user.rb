class User < ActiveRecord::Base
  has_event :confirm, subject: :email
end
