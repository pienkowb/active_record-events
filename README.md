# ActiveRecord::Events

An ActiveRecord extension providing convenience methods for timestamp management.

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

Recording a timestamp in order to mark that an event occurred to an object is a common practice when dealing with ActiveRecord models – `created_at` and `updated_at` fields handled by ActiveRecord itself are a good example of such approach.
This gem allows you to manage custom timestamp fields in the exact same manner.

Consider a `Task` model with a `completed_at` field and the following methods:

```ruby
class Task < ActiveRecord::Base
  def completed?
    completed_at.present?
  end

  def complete
    complete! unless completed?
  end

  def complete!
    touch :completed_at
  end
end
```

Instead of defining these three methods explicitly, you can use a macro provided by the gem.

```ruby
class Task < ActiveRecord::Base
  handles :complete
end
```

This approach is very efficient when more than one field has to be handled that way.
In such a case, many lines of code can be replaced with an expressive one-liner.

```ruby
handles :complete, :archive
```

### Scopes

In addition, the macro defines two scope methods – one for retrieving objects with a recorded timestamp and one for those without it, for example:

```ruby
scope :not_completed, -> { where completed_at: nil }
scope :completed, -> { where.not completed_at: nil }
```

## See also

- [ActiveRecord::Enum](http://api.rubyonrails.org/classes/ActiveRecord/Enum.html)