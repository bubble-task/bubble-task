require 'rails_helper'

describe 'GET /achievements' do
  before do
    user
    request_oauth_sign_in(auth_hash: auth_hash)
    tasks
  end

  let(:user) { create_user_from_oauth_credential(auth_hash) }
  let(:auth_hash) { generate_auth_hash }

  let(:tasks) do
    uncompleted_a
    completed_a
  end

  let(:uncompleted_a) { create_task(author_id: user.id, title: '未完了A') }

  let(:completed_a) do
    create_task(author_id: user.id, title: '完了A').tap do |t|
      TaskCompletion.new(task_id: t.id).run
    end
  end

  context '期間を指定しない' do
    skip do
      get achievements_path(start_on: nil, end_on: nil)
      expect(response).to assigns
    end
  end
end
