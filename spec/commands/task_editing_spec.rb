require 'rails_helper'

describe TaskEditing do
  context '個人タスクにする' do
    context 'タグがある場合' do
      let(:user) { create_user_from_oauth_credential }
      let(:other_user) { create_user_from_oauth_credential }
      it do
        task = create_task(author_id: other_user.id, title: 'タイトル', tags: %w(タグ))
        command = TaskEditing.new(task, TaskEditingForm.new({ title: 'タイトル', tag_words: '' }.merge(task_id: task.id)))
        command.run(user)
        updated_task = Task.find(task.id)
        expect(updated_task.personal_task_owner).to eq(user)
      end
    end
  end
end
