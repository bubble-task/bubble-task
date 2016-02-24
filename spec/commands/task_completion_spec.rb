require 'rails_helper'

describe TaskCompletion do
  let(:user_a) { create_user_from_oauth_credential }
  let(:user_b) { create_user_from_oauth_credential }

  context 'サインアップしていないタスクを完了にする場合' do
    it do
      task = create_task(author_id: user_a.id, title: '公開タスク', tags: %w(tag), assignees: [user_b])
      command = described_class.new(task_id: task.id)
      expect { command.run(user_a.id) }.to raise_error(TaskCompletionNotPermitted)
    end
  end
end
