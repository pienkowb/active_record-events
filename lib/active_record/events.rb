require 'active_support'

require 'active_record/events/version'

require 'active_record/events/naming'
require 'active_record/events/method_factory'
require 'active_record/events/extension'

require 'active_record/events/macro'

ActiveSupport.on_load(:active_record) do
  extend ActiveRecord::Events::Extension
end
