require 'spec_helper'
require 'generators/active_record/event/event_generator'

RSpec.describe ActiveRecord::Generators::EventGenerator, type: :generator do
  arguments %w[
    task complete
    --field-type=date
    --skip-scopes
    --strategy=time_comparison
  ]

  destination File.expand_path('../../../../tmp', __dir__)

  before { prepare_destination }

  it 'generates a migration file' do
    run_generator

    assert_migration 'db/migrate/add_completed_on_to_tasks' do |migration|
      assert_instance_method :change, migration do |content|
        assert_match 'add_column :tasks, :completed_on, :date', content
      end
    end
  end

  context 'when the model file exists' do
    before do
      write_file 'app/models/task.rb', <<-RUBY.strip_heredoc
        class Task < ActiveRecord::Base
        end
      RUBY
    end

    it 'updates the model file' do
      run_generator

      assert_file 'app/models/task.rb', <<-RUBY.strip_heredoc
        class Task < ActiveRecord::Base
          has_event :complete, field_type: :date, skip_scopes: true, strategy: :time_comparison
        end
      RUBY
    end
  end

  context "when the model file doesn't exist" do
    it "doesn't create the model file" do
      run_generator
      assert_no_file 'app/models/task.rb'
    end
  end
end
