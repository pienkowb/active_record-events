require 'spec_helper'
require 'generators/active_record/event_generator'

RSpec.describe ActiveRecord::Generators::EventGenerator, type: :generator do
  arguments %w[user confirm --object=email --skip-scopes]
  destination File.expand_path('../../../tmp', __dir__)

  before { prepare_destination }

  it 'generates a migration file' do
    run_generator

    assert_migration 'db/migrate/add_email_confirmed_at_to_users' do |content|
      assert_match <<-RUBY.strip_heredoc, content
        class AddEmailConfirmedAtToUsers < ActiveRecord::Migration[5.2]
          def change
            add_column :users, :email_confirmed_at, :datetime
          end
        end
      RUBY
    end
  end

  context 'when the model file exists' do
    before do
      write_file 'app/models/user.rb', <<-RUBY.strip_heredoc
        class User < ActiveRecord::Base
        end
      RUBY
    end

    it 'updates the model file' do
      run_generator

      assert_file 'app/models/user.rb', <<-RUBY.strip_heredoc
        class User < ActiveRecord::Base
          has_event :confirm, object: :email, skip_scopes: true
        end
      RUBY
    end
  end

  context "when the model file doesn't exist" do
    it "doesn't create the model file" do
      run_generator
      assert_no_file 'app/models/user.rb'
    end
  end
end
