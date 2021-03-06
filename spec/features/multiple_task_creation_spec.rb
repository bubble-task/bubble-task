require 'rails_helper'

describe '複数のタスクを作成する' do
  context '複数のタスクに同じタグを付加する場合' do
    before { oauth_sign_in }

    let(:common_tag) { '共通のタグ' }

    def create_task_with_tags(title, tag_words)
      create_task_from_ui(title: title, tag_words: tag_words)
      task = Task.last
      TaskAssignment.new(task_id: task.id, assignee_id: User.last.id).run
      task
    end

    def extract_tags(task_id)
      first("#task_#{task_id} .tags").text
    end

    it do
      task1 = create_task_with_tags('タスク1のタイトル', common_tag)
      task2 = create_task_with_tags('タスク2のタイトル', common_tag)
      visit root_path

      task1_tag_on_page = extract_tags(task1.id)
      task2_tag_on_page = extract_tags(task2.id)

      expect(task1_tag_on_page).to eq(common_tag)
      expect(task2_tag_on_page).to eq(common_tag)
    end
  end
end
