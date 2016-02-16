require 'rails_helper'

describe TaskCreation do
  let(:user) { create_user_from_oauth_credential }
  let(:title) { 'タスクのタイトル' }
  let(:tag_words) { 'タグA' }
  let(:created_task) { Task.last }

  context '通常のタスクを作成する場合' do
    it do
      command = TaskCreation.new(TaskCreationForm.new(title: title, tag_words: tag_words))
      command.run(user)
      expect(created_task.title).to eq(title)
      expect(created_task.tags).to eq([tag_words])
      expect(created_task.personal?).to be_falsey
    end
  end

  context '個人タスクを作成する場合' do
    it do
      command = TaskCreation.new(TaskCreationForm.new(title: title))
      command.run(user)
      expect(created_task.title).to eq(title)
      expect(created_task.tags).to be_empty
      expect(created_task.personal?).to be_truthy
    end
  end
end
