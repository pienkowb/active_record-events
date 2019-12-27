class Task < ActiveRecord::Base
  has_event :complete

  def complete!
    super
    logger = Logger.new(STDOUT)
    logger.info("Task #{id} has been completed")
  end
end
