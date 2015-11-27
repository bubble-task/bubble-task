require 'rails_helper'

describe 'タスク編集時にバリデーションをかける' do
  before do
    user
    oauth_sign_in(auth_hash: auth_hash)
  end

  let(:user) { create_user_from_oauth_credential(auth_hash) }
  let(:auth_hash) { generate_auth_hash }

  let(:task) { create_task(user.id, old_title, old_description, old_tags) }
  let(:old_title) { '編集前のタイトル' }
  let(:old_description) { '編集前の説明' }
  let(:old_tags) { %w(タグ1 タグ2) }
  let(:old_tag_words) { old_tags.join(' ') }

  describe 'タイトル' do
    subject do
      update_task_from_ui(task, title: title)
      page
    end

    context '未入力' do
      let(:title) { '' }
      it { is_expected.to have_content 'タイトルを入力してください' }
    end

    context '最大文字数+1文字入力' do
      let(:title) { 'a' * 41 }
      it { is_expected.to have_content 'タイトルは40文字以内で入力してください' }
    end

    context '最大文字数入力' do
      let(:title) { 'a' * 40 }
      it { is_expected.to have_link title }
    end
  end

  describe '説明' do
    subject do
      update_task_from_ui(task, description: description)
      page
    end

    context '最大文字数+1文字入力' do
      let(:description) { 'a' * 5001 }

      it { is_expected.to have_content '説明は5000文字以内で入力してください' }
    end

    context '最大文字数入力' do
      let(:description) { 'a' * 5000 }
      it { is_expected.to have_link old_title }
    end
  end

  describe 'タグ' do
    let(:out_of_boundary_length) { 17 }
    let(:inside_of_boundary_length) { 16 }

    subject do
      update_task_from_ui(task, tag_words: tag_words)
      page
    end

    context '全て最大文字数以内で入力' do
      let(:tag_words) { "#{'a' * 8} #{'b' * 9}" }
      it { is_expected.to have_link(old_title) }
    end

    context '最大文字数+1を単独で入力' do
      let(:tag_words) { 'a' * out_of_boundary_length }
      it { is_expected.to have_content("タグ「#{tag_words}」は16文字以内で入力してください") }
    end

    context '最大文字数+1と最大文字数を一つずつ入力' do
      let(:invalid_tag) { 'b' * out_of_boundary_length }
      let(:tag_words) { "#{'a' * inside_of_boundary_length} #{invalid_tag}" }

      it { is_expected.to have_content("タグ「#{invalid_tag}」は16文字以内で入力してください") }
    end
  end
end
