# ActiveRecord::Events [![Gem version](https://img.shields.io/gem/v/active_record-events)](https://rubygems.org/gems/active_record-events) [![Build status](https://img.shields.io/github/actions/workflow/status/pienkowb/active_record-events/test.yml?branch=develop)](https://github.com/pienkowb/active_record-events/actions/workflows/test.yml?query=branch%3Adevelop) [![Coverage status](https://img.shields.io/coveralls/github/pienkowb/active_record-events/develop)](https://coveralls.io/github/pienkowb/active_record-events) [![Maintainability status](https://img.shields.io/codeclimate/maintainability/pienkowb/active_record-events)](https://codeclimate.com/github/pienkowb/active_record-events)

An ActiveRecord extension providing convenience methods for timestamp management.

## Screencast

<a href="https://www.youtube.com/watch?v=TIR7YDF3O-4">
  <img src="https://img.youtube.com/vi/TIR7YDF3O-4/maxresdefault.jpg" title="ActiveRecord::Events - Awesome Ruby Gems" width="50%">
</a>

[Watch screencast](https://www.youtube.com/watch?v=TIR7YDF3O-4) (courtesy of [Mike Rogers](https://github.com/MikeRogers0))

## Installation

Add the following line to your application's Gemfile:

```ruby
gem 'active_record-events'
```

Install the gem with Bundler:

```
$ bundle install
```

Or do it manually by running:

```
$ gem install active_record-events
```

## Usage

Recording a timestamp in order to mark that an event occurred to an object is a common practice when dealing with ActiveRecord models.
A good example of such an approach is how ActiveRecord handles the `created_at` and `updated_at` fields.
This gem allows you to manage custom timestamp fields in the exact same manner.

### Example

Consider a `Task` model with a `completed_at` field and the following methods:

```ruby
class Task < ActiveRecord::Base
  def completed?
    completed_at.present?
  end

  def not_completed?
    !completed?
  end

  def complete
    complete! if not_completed?
  end

  def complete!
    touch(:completed_at)
  end

  def self.complete_all
    touch_all(:completed_at)
  end
end
```

Instead of defining all of these methods by hand, you can use the `has_event` macro provided by the gem.

```ruby
class Task < ActiveRecord::Base
  has_event :complete
end
```

As a result, the methods will be generated automatically.

*It's important to note that the `completed_at` column has to already exist in the database.*
*Consider [using the generator](#using-a-rails-generator) to create a necessary migration.*

### Scopes

In addition, the macro defines two scope methods – one for retrieving objects with a recorded timestamp and one for those without it, for example:

```ruby
scope :not_completed, -> { where(completed_at: nil) }
scope :completed, -> { where.not(completed_at: nil) }
```

The inclusion of scope methods can be omitted by passing the `skip_scopes` flag.

```ruby
has_event :complete, skip_scopes: true
```

### Multiple events

Using the macro is efficient when more than one field has to be handled that way.
In such a case, many lines of code can be replaced with an expressive one-liner.

```ruby
has_events :complete, :archive
```

### Date fields

In case of date fields, which by convention have names ending with `_on` instead of `_at` (e.g. `completed_on`), the `field_type` option needs to be passed to the macro:

```ruby
has_event :complete, field_type: :date
```

### Custom field name

If there's a field with a name that doesn't follow the naming convention (i.e. does not end with `_at` or `_on`), you can pass it as the `field_name` option.

```ruby
has_event :complete, field_name: :completion_time
```

Note that the `field_name` option takes precedence over the `field_type` option.

### Comparison strategy

By default the timestamp's presence will dictate the behavior. However in some cases you may want to check against the current time.

You can do this with the `strategy` option, which can be either `presence` or `time_comparison`:

```ruby
has_event :complete, strategy: :time_comparison
```

**Example:**

```ruby
task.completed_at = 1.hour.ago
task.completed? # => true

task.completed_at = 1.hour.from_now
task.completed? # => false
```

### Specifying an object

There are events which do not relate to a model itself but to one of its attributes – take the `User` model with the `email_confirmed_at` field as an example.
In order to keep method names grammatically correct, you can specify an object using the `object` option.

```ruby
class User < ActiveRecord::Base
  has_event :confirm, object: :email
end
```

This will generate the following methods:

- `email_not_confirmed?`
- `email_confirmed?`
- `confirm_email`
- `confirm_email!`
- `confirm_all_emails` (class method)

As well as these two scopes:

- `email_confirmed`
- `email_not_confirmed`

### Using a Rails generator

If you want to quickly add a new event, you can make use of a Rails generator provided by the gem:

```
$ rails generate active_record:event task complete
```

It will create a necessary migration and insert a `has_event` statement into the model class.

```ruby
# db/migrate/XXX_add_completed_at_to_tasks.rb

class AddCompletedAtToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :completed_at, :datetime
  end
end
```

```ruby
# app/models/task.rb

class Task < ActiveRecord::Base
  has_event :complete
end
```

All of the macro options are supported by the generator and can be passed via the command line.
For instance:

```
$ rails generate active_record:event user confirm --object=email --skip-scopes
```

For more information, run the generator with the `--help` option.

### Overriding methods

If there's a need to override any of the methods generated by the macro, you can define a new method with the same name in the corresponding model class.
This applies to instance methods as well as class methods.
In both cases, the `super` keyword invokes the original method.

```ruby
class Task < ActiveRecord::Base
  has_event :complete

  def complete!
    super
    logger.info("Task #{id} has been completed")
  end

  def self.complete_all
    super
    logger.info('All tasks have been completed')
  end
end
```

## Contributors

- [Bartosz Pieńkowski](https://github.com/pienkowb)
- [Tomasz Skupiński](https://github.com/tskupinski)
- [Oskar Janusz](https://github.com/oskaror)
- [Mike Rogers](https://github.com/MikeRogers0)
- [Spencer Rogers](https://github.com/serogers)

## See also

- [ActiveRecord::Enum](https://api.rubyonrails.org/classes/ActiveRecord/Enum.html)
