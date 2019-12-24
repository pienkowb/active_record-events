# ActiveRecord::Events [![Gem version](https://img.shields.io/gem/v/active_record-events.svg)](https://rubygems.org/gems/active_record-events) [![Build status](https://img.shields.io/travis/pienkowb/active_record-events.svg)](https://travis-ci.org/pienkowb/active_record-events)

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
  def not_completed?
    !completed?
  end

  def completed?
    completed_at.present?
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

Instead of defining these five methods explicitly, you can use a macro provided by the gem.

```ruby
class Task < ActiveRecord::Base
  has_event :complete
end
```

This approach is very efficient when more than one field has to be handled that way.
In such a case, many lines of code can be replaced with an expressive one-liner.

```ruby
has_events :complete, :archive
```

### Scopes

In addition, the macro defines two scope methods – one for retrieving objects with a recorded timestamp and one for those without it, for example:

```ruby
scope :not_completed, -> { where(completed_at: nil) }
scope :completed, -> { where.not(completed_at: nil) }
```

### Date field

In case of date fields, which by convention have names ending with `_on` instead of `_at` (e.g. `delivered_on`), the `field_type` option needs to be passed to the macro:

```ruby
has_event :deliver, field_type: :date
```

### Object

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

## See also

- [ActiveRecord::Enum](http://api.rubyonrails.org/classes/ActiveRecord/Enum.html)
