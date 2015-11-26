require 'rails_helper'

describe 'タスク作成時にバリデーションをかける' do
  before do
    oauth_sign_in
  end

  let(:valid_title) { 'タスクのタイトル' }
  let(:out_of_boundary_length) { 17 }
  let(:inside_of_boundary_length) { 16 }

  it do
    create_task_from_ui('')
    expect(page).to have_content 'タイトルを入力してください'
  end

  it do
    title = 'a' * 40
    create_task_from_ui('a' * 40)
    expect(page).to have_link(title)
  end

  it do
    create_task_from_ui('a' * 41)
    expect(page).to have_content 'タイトルは40文字以内で入力してください'
  end

  it do
    create_task_from_ui(valid_title, 'a' * 5001)
    expect(page).to have_content '説明は5000文字以内で入力してください'
  end

  it do
    create_task_from_ui(valid_title, 'a' * 5000)
    expect(page).to have_link(valid_title)
  end

  it do
    tag_words = 'a' * out_of_boundary_length
    create_task_from_ui(valid_title, nil, tag_words)
    expect(page).to have_content("タグ「#{tag_words}」は16文字以内で入力してください")
  end

  it do
    invalid_tag = 'b' * out_of_boundary_length
    create_task_from_ui(valid_title, nil, "#{'a' * inside_of_boundary_length} #{invalid_tag}")
    expect(page).to have_content("タグ「#{invalid_tag}」は16文字以内で入力してください")
  end

  it do
    create_task_from_ui(valid_title, nil, "#{'a' * 8} #{'b' * 9}")
    expect(page).to have_link('タスクのタイトル')
  end
end
