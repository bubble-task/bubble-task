require 'rails_helper'

describe 'Calculation' do
  it do
    post calculations_path, calculation: { left: '1', right: '2', operator: 'plus' }
    expect(response.body).to include 'Operator is not operation symbol'
  end
end
