RSpec::Matchers.define :have_method do |expected|
  match do |actual|
    actual.public_instance_methods.include?(expected)
  end
end
