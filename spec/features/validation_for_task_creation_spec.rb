require 'rails_helper'

describe 'タスク作成時にバリデーションをかける' do
  include TaskCreationHelper
  before do
    oauth_sign_in
    visit new_task_path
  end

  let(:valid_title) { 'タスクのタイトル' }
  let(:out_of_boundary_length) { 17 }
  let(:inside_of_boundary_length) { 16 }

  it do
    create_task('')
    expect(page).to have_content 'タイトルを入力してください'
  end

  it do
    create_task('a' * 40)
    expect(page).to have_link(title)
  end

  it do
    create_task('a' * 41)
    expect(page).to have_content 'タイトルは40文字以内で入力してください'
  end

  it do
    create_task(valid_title, 'a' * 256)
    expect(page).to have_content '説明は255文字以内で入力してください'
  end

  it do
    create_task(valid_title, 'a' * 255)
    expect(page).to have_link(valid_title)
  end

  it do
    tag_words = 'a' * out_of_boundary_length
    create_task(valid_title, nil, tag_words)
    expect(page).to have_content("タグ「#{tag_words}」は16文字以内で入力してください")
  end

  it do
    invalid_tag = 'b' * out_of_boundary_length
    create_task(valid_title, nil, "#{'a' * inside_of_boundary_length} #{invalid_tag}")
    expect(page).to have_content("タグ「#{invalid_tag}」は16文字以内で入力してください")
  end

  it do
    create_task(valid_title, nil, "#{'a' * 8} #{'b' * 9}")
    expect(page).to have_link('タスクのタイトル')
  end
end
