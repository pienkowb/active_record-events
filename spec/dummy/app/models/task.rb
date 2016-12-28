class Task < ActiveRecord::Base
  has_event :complete
end
