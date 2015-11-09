require 'rails_helper'

describe 'Calculation' do
  before do
    visit new_calculation_path
    fill_in 'Left', with: left
    select operator, from: 'calculation_operator'
    fill_in 'Right', with: right
    click_button 'Compute'
  end

  context '足し算を行う場合' do
    let(:left) { 1 }
    let(:right) { 2 }
    let(:operator) { '+' }
    it { expect(page).to have_content '1 + 2 = 3' }
  end

  context '引き算を行う場合' do
    let(:left) { 2 }
    let(:right) { 1 }
    let(:operator) { '-' }
    it { expect(page).to have_content '2 - 1 = 1' }
  end

  context '掛け算を行う場合' do
    let(:left) { 3 }
    let(:right) { 4 }
    let(:operator) { '*' }
    it { expect(page).to have_content '3 * 4 = 12' }
  end

  context '割り算を行う場合' do
    let(:left) { 6 }
    let(:right) { 2 }
    let(:operator) { '/' }
    it { expect(page).to have_content '6 / 2 = 3' }
  end

  context '整数値以外を入力した場合' do
    let(:left) { 'one' }
    let(:right) { 2 }
    let(:operator) { '+' }
    it { expect(page).to have_content 'Left is not a number' }
  end
end
