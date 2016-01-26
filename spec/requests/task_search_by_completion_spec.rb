require 'rails_helper'

describe 'GET /search' do
  before do
    request_sign_in_as(user)
  end

  let(:user) { create_user_from_oauth_credential }

  let(:completed_task) { create_task(author_id: user.id, title: '完了', completed_at: :now, assignees: [user]) }
  let(:uncompleted_task) { create_task(author_id: user.id, title: '未完了', assignees: [user]) }
end
