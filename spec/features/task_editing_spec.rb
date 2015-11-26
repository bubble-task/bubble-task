require 'rails_helper'

describe 'タスクの編集' do
  before do
    user
    oauth_sign_in(auth_hash: auth_hash)
    task
  end

  let(:user) { create_user_from_oauth_credential(auth_hash) }
  let(:auth_hash) { generate_auth_hash }

  let(:task) { create_task(user.id, old_title, old_description, old_tags) }
  let(:old_title) { '編集前のタイトル' }
  let(:old_description) { '編集前の説明' }
  let(:old_tags) { %w(タグ1 タグ2) }
  let(:old_tag_words) { old_tags.join(' ') }

  let(:new_title) { '新しいタイトル' }
  let(:new_description) { '新しい説明' }

  let(:title_on_page) { first('.task-title').text }
  let(:description_on_page) { first('.task-description').text }

  describe '編集画面' do
    it do
      visit task_url(task.id)
      click_link(I18n.t('helpers.actions.edit'))

      filled_old_title = find('#task_editing_title').value
      expect(filled_old_title).to eq(old_title)

      filled_old_description = find('#task_editing_description').value
      expect(filled_old_description).to eq(old_description)

      filled_old_tag_words = find('#task_tag_words', visible: false).value
      expect(filled_old_tag_words).to eq(old_tag_words)
    end
  end

  describe 'タイトルを編集' do
    it do
      visit task_url(task.id)
      click_link(I18n.t('helpers.actions.edit'))

      fill_in 'task_editing[title]', with: new_title
      click_button I18n.t('helpers.submit.update')

      click_link new_title
      expect(title_on_page).to eq(new_title)
      expect(description_on_page).to eq(old_description)
    end
  end

  describe '説明を編集' do
    it do
      visit task_url(task.id)
      click_link(I18n.t('helpers.actions.edit'))

      fill_in 'task_editing[description]', with: new_description
      click_button I18n.t('helpers.submit.update')

      click_link old_title
      expect(title_on_page).to eq(old_title)
      expect(description_on_page).to eq(new_description)
    end
  end
end
