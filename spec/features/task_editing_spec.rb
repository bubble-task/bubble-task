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

  let(:title_on_page) { first('.task-title').text }
  let(:description_on_page) { first('.task-description').text }
  let(:tags_on_page) { first('.tags').text.split(/\s+/) }

  describe '編集画面' do
    it '既存のタグ・タイトル・説明が入力されていること' do
      visit task_url(task.id)
      click_link(I18n.t('helpers.actions.edit'))

      filled_old_title = find('#task_parameters_title').value
      expect(filled_old_title).to eq(old_title)

      filled_old_description = find('#task_parameters_description').value
      expect(filled_old_description).to eq(old_description)

      filled_old_tag_words = find('#task_tag_words', visible: false).value
      expect(filled_old_tag_words).to eq(old_tag_words)
    end
  end

  describe 'タイトルを編集' do
    let(:new_title) { '新しいタイトル' }

    it 'タイトルのみ更新されていること' do
      update_task_from_ui(task, title: new_title)
      click_link new_title
      expect(title_on_page).to eq(new_title)
      expect(description_on_page).to eq(old_description)
      expect(tags_on_page).to eq(old_tags)
    end
  end

  describe '説明を編集' do
    context '説明を変更' do
      let(:new_description) { '新しい説明' }

      it '説明のみ更新されていること' do
        update_task_from_ui(task, description: new_description)
        click_link old_title
        expect(title_on_page).to eq(old_title)
        expect(description_on_page).to eq(new_description)
        expect(tags_on_page).to eq(old_tags)
      end
    end

    context '説明を削除' do
      let(:new_description) { '' }

      it '説明が削除されていること' do
        update_task_from_ui(task, description: new_description)
        click_link old_title
        expect(first('.task-description')).to be_nil
        expect(title_on_page).to eq(old_title)
        expect(tags_on_page).to eq(old_tags)
      end
    end
  end

  describe 'タグを編集' do
    skip 'タグを1つ追加' do
      let(:new_tag_words) { 'タグ1 タグ2 タグ3' }

      it do
        update_task_from_ui(task, tag_words: new_tag_words)
        click_link old_title
        expect(title_on_page).to eq(old_title)
        expect(description_on_page).to eq(old_description)
        expect(tags_on_page).to eq(%w(タグ1 タグ2 タグ3))
      end
    end

    skip 'タグを1つ削除' do
      let(:new_tag_words) { 'タグ2' }

      it do
        update_task_from_ui(task, tag_words: new_tag_words)
        click_link old_title
        expect(title_on_page).to eq(old_title)
        expect(description_on_page).to eq(old_description)
        expect(tags_on_page).to eq(%w(タグ2))
      end
    end

    skip 'タグを全て入れ替え' do
      let(:new_tag_words) { 'タグ3 タグ4' }

      it do
        update_task_from_ui(task, tag_words: new_tag_words)
        click_link old_title
        expect(title_on_page).to eq(old_title)
        expect(description_on_page).to eq(old_description)
        expect(tags_on_page).to eq(%w(タグ3 タグ4))
      end
    end
  end
end
