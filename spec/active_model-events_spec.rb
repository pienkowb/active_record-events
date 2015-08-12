require 'spec_helper'

RSpec.describe ActiveModel::Events do
  it 'generates a field name' do
    field_name = subject.field_name('complete')
    expect(field_name).to eq('completed_at')
  end
end
