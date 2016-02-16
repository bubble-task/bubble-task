require 'rails_helper'

describe TaskEditing do
  context '個人タスクにする' do
    context 'タグがある場合' do
      let(:user) { create_user_from_oauth_credential }
      let(:other_user) { create_user_from_oauth_credential }
      let(:task) { create_task(author_id: other_user.id, title: 'タイトル', tags: %w(タグ), assignees: [other_user]) }
      let(:updated_task) do
        command = TaskEditing.new(task, TaskEditingForm.new({ title: 'タイトル', tag_words: '' }.merge(task_id: task.id)))
        command.run(user)
        Task.find(task.id)
      end

      it { expect(updated_task.personal_task_owner).to eq(user) }

      it { expect(updated_task.assignees).to be_empty }
    end
  end
end
