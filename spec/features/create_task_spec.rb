require 'rails_helper'

describe 'タスクを登録する' do
  it do
    visit new_task_path
    fill_in 'タイトル', with: 'タスクのタイトル'
    fill_in '説明', with: 'タスクの説明'
    click_button '作成する'
    expect(page).to have_content 'タスクのタイトル'
  end
end
