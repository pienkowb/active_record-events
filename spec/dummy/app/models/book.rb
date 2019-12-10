class Book < ActiveRecord::Base
  has_event :borrow, field_type: :date
end
