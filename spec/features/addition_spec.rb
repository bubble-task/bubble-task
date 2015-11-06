describe 'Addition' do
  it do
    visit new_addition_path
    fill_in 'Left', with: 1
    fill_in 'Right', with: 2
    expect(page).to have_content '1 + 2 = 3'
  end
end
