require 'rails_helper'

describe 'タスクの編集' do
  before do
    sign_in_as(user)
    task
  end

  let(:user) { create_user_from_oauth_credential }

  let(:task) { create_task(author_id: user.id, title: old_title, description: old_description, tags: old_tags, assignees: [user]) }
  let(:old_title) { '編集前のタイトル' }
  let(:old_description) { '編集前の説明' }
  let(:old_tags) { %w(タグ1 タグ2) }
  let(:old_tag_words) { old_tags.join(' ') }
  let(:old_deadline) { Time.zone.parse("#{old_deadline_date} #{old_deadline_hour}:#{old_deadline_minutes}") }
  let(:old_deadline_date) { '2016/02/03' }
  let(:old_deadline_hour) { '10' }
  let(:old_deadline_minutes) { '0' }

  let(:title_on_page) { first('.task-title').text }
  let(:description_on_page) { first('.task-description').text }
  let(:tags_on_page) { first('.tags').text.split(/\s+/) }

  describe '編集画面' do
    let(:task) do
      create_task(author_id: user.id, title: old_title, description: old_description, tags: old_tags, assignees: [user], deadline: old_deadline)
    end

    it '既存のタグ・タイトル・説明・期限が入力されていること' do
      visit task_url(task.id)
      click_link(I18n.t('helpers.actions.edit'))

      filled_old_title = find('#task_parameters_title').value
      expect(filled_old_title).to eq(old_title)

      filled_old_description = find('#task_parameters_description').value
      expect(filled_old_description).to eq(old_description)

      filled_old_tag_words = find('#task_tag_words', visible: false).value
      expect(filled_old_tag_words).to eq(old_tag_words)

      filled_old_deadline_date = find('#task_parameters_deadline_date')['data-value']
      expect(filled_old_deadline_date).to eq(old_deadline_date)

      filled_old_deadline_hour = find('#task_parameters_deadline_hour').value
      expect(filled_old_deadline_hour).to eq(old_deadline_hour)

      filled_old_deadline_minutes = find('#task_parameters_deadline_minutes').value
      expect(filled_old_deadline_minutes).to eq(old_deadline_minutes)
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
    context 'タグを1つ追加' do
      let(:new_tag_words) { 'タグ1 タグ2 タグ3' }

      it do
        update_task_from_ui(task, tag_words: new_tag_words)
        click_link old_title
        expect(title_on_page).to eq(old_title)
        expect(description_on_page).to eq(old_description)
        expect(tags_on_page).to eq(%w(タグ1 タグ2 タグ3))
      end

      context '個人タスクにタグを追加' do
        let(:old_tags) { [] }

        it do
          update_task_from_ui(task, tag_words: new_tag_words)
          click_link old_title
          expect(title_on_page).to eq(old_title)
          expect(description_on_page).to eq(old_description)
          expect(tags_on_page).to eq(%w(タグ1 タグ2 タグ3))
        end
      end
    end

    context 'タグを1つ削除' do
      let(:new_tag_words) { 'タグ2' }

      it do
        update_task_from_ui(task, tag_words: new_tag_words)
        click_link old_title
        expect(title_on_page).to eq(old_title)
        expect(description_on_page).to eq(old_description)
        expect(tags_on_page).to eq(%w(タグ2))
      end
    end

    context 'タグを全て削除' do
      let(:new_tag_words) { '' }

      context '自分が作成したタスク' do
        it '自分の個人タスクになること' do
          update_task_from_ui(task, tag_words: new_tag_words)
          click_link old_title
          expect(title_on_page).to eq(old_title)
          expect(description_on_page).to eq(old_description)
          expect(tags_on_page).to eq(%w(個人タスク))
        end
      end

      context '他人が作成したタスク' do
        let(:other_user) { create_user_from_oauth_credential(generate_auth_hash(email: 'other_user@gaiax.com')) }
        let(:task) { create_task(author_id: other_user.id, title: old_title, tags: old_tags, assignees: [other_user]) }

        it '自分の個人タスクになること' do
          update_task_from_ui(task, tag_words: new_tag_words)
          expect(title_on_page).to eq(old_title)
          expect(tags_on_page).to eq(%w(個人タスク))
        end
      end

      context 'サインアップしたタスクを他人の個人タスクに変更された場合' do
        let(:other_user) { create_user_from_oauth_credential(generate_auth_hash(email: 'other_user@gaiax.com')) }
        let(:task) { create_task(author_id: other_user.id, title: old_title, tags: old_tags, assignees: [user]) }

        it '編集した他人の個人タスクになること' do
          command = TaskEditing.new(task, TaskEditingForm.new({ title: 'タイトル', tag_words: '' }.merge(task_id: task.id)))
          command.run(other_user)
          visit root_path
          expect(all('.task-summary').size).to eq(0)
        end
      end
    end

    context 'タグを全て入れ替え' do
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

  describe '期限を編集' do
    context '期限を設定' do
      let(:deadline) { Time.zone.parse('2016/02/03 10:00') }
      let(:deadline_text) { first('.task-deadline').text }

      context '期限が設定されていない場合' do
        it do
          update_task_from_ui(task, deadline: deadline)
          expect(deadline_text).to eq('2016/02/03 10:00')
        end
      end

      context '期限がすでに設定されている場合' do
        let(:task) do
          create_task(author_id: user.id, title: old_title, assignees: [user], deadline: deadline.advance(days: 1))
        end

        it do
          update_task_from_ui(task, deadline: deadline)
          expect(deadline_text).to eq('2016/02/03 10:00')
        end
      end
    end

    context '期限を削除する', js: true do
      let(:deadline_text) { first('.task-deadline').text }

      context '期限がすでに設定されている場合' do
        let(:task) { create_task(author_id: user.id, title: old_title, assignees: [user], deadline: Time.current) }

        it do
          disable_deadline_from_ui(task)
          expect(deadline_text).to be_blank
        end
      end

      context '期限がすでに設定されている場合' do
        it do
          disable_deadline_from_ui(task)
          expect(deadline_text).to be_blank
        end
      end
    end
  end
end
