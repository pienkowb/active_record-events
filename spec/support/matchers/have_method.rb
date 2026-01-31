RSpec::Matchers.define :have_method do |expected|
  match do |actual|
    actual.public_method_defined?(expected)
  end
end
