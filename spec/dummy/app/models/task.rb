class Task < ActiveRecord::Base
  has_event :complete

  def complete!
    super
    logger.info("Task #{id} has been completed")
  end

  def self.complete_all
    super
    logger.info("All tasks have been completed")
  end
end
