require 'rails_helper'

describe 'タスク編集時にバリデーションをかける' do
  before do
    user
    oauth_sign_in(auth_hash: auth_hash)
    visit edit_task_path(task.id)
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
      fill_in 'task_parameters[title]', with: title
      click_button I18n.t('helpers.submit.update')
      page
    end

    context '未入力' do
      let(:title) { '' }
      it { is_expected.to have_content 'タイトルを入力してください' }
    end

    context '41文字入力' do
      let(:title) { 'a' * 41 }
      it { is_expected.to have_content 'タイトルは40文字以内で入力してください' }
    end

    context '40文字入力' do
      let(:title) { 'a' * 40 }
      it { is_expected.to have_link title }
    end
  end

  describe '説明' do
    subject do
      fill_in 'task_parameters[description]', with: description
      click_button I18n.t('helpers.submit.update')
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
end
