require 'rails_helper'

describe 'Addition' do
  it do
    visit new_calculation_path
    fill_in 'Left', with: 1
    fill_in 'Right', with: 2
    click_button 'Compute'
    expect(page).to have_content '1 + 2 = 3'
  end
end
