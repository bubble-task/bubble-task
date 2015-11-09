require 'rails_helper'

describe 'Calculation' do
  before do
    visit new_calculation_path
  end

  context '足し算を行う場合' do
    it do
      fill_in 'Left', with: 1
      select '+', from: 'calculation_operator'
      fill_in 'Right', with: 2
      click_button 'Compute'
      expect(page).to have_content '1 + 2 = 3'
    end
  end

  context '引き算を行う場合' do
    it do
      fill_in 'Left', with: 2
      select '-', from: 'calculation_operator'
      fill_in 'Right', with: 1
      click_button 'Compute'
      expect(page).to have_content '2 - 1 = 1'
    end
  end

  context '掛け算を行う場合' do
    it do
      fill_in 'Left', with: 3
      select '*', from: 'calculation_operator'
      fill_in 'Right', with: 4
      click_button 'Compute'
      expect(page).to have_content '3 * 4 = 12'
    end
  end
end
