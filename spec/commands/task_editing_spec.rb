require 'rails_helper'

describe TaskEditing do
  let(:user) { create_user_from_oauth_credential }
  let(:updated_task) do
    command = TaskEditing.new(task, TaskEditingForm.new({ title: 'タイトル', tag_words: new_tag_words }.merge(task_id: task.id)))
    command.run(user.id)
    Task.find(task.id)
  end

  context '個人タスクにする' do
    context 'タグがある場合' do
      let(:new_tag_words) { '' }
      let(:other_user) { create_user_from_oauth_credential(generate_auth_hash(email: 'other_user@gaiax.com')) }
      let(:task) { create_task(author_id: other_user.id, title: 'タイトル', tags: %w(タグ), assignees: [other_user]) }

      it { expect(updated_task.personal_task_owner).to eq(user) }

      it { expect(updated_task.assignees).to be_empty }
    end
  end

  context '個人タスクを通常のタスクにする場合' do
    let(:new_tag_words) { %w(タグ) }
    let(:task) { create_task(author_id: user.id, title: 'タイトル') }

    it { expect(updated_task.personal?).to be_falsey }
  end

  context '通常のタスクのままの場合' do
    let(:task) { create_task(author_id: user.id, title: 'タイトル', tags: %w(タグ1), assignees: [user]) }
    let(:new_tag_words) { 'タグ2' }

    it { expect(updated_task.personal?).to be_falsey }

    it { expect(updated_task.assignees).to eq([user]) }
  end
end
