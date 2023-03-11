class Task < ActiveRecord::Base
  has_event :complete
  has_event :archive, skip_scopes: true
  has_events :expire, strategy: :time_comparison
  has_event :notify, field_type: :date, strategy: :time_comparison

  def complete!
    super
    logger.info("Task #{id} has been completed")
  end

  def self.complete_all
    super
    logger.info('All tasks have been completed')
  end
end
