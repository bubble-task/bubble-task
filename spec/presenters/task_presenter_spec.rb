require 'rails_helper'

describe TaskPresenter do
  let(:user) { create_user_from_oauth_credential(generate_auth_hash) }

  describe '#cancel_completion_link' do
    context '完了していない場合' do
      it do
        presenter = TaskPresenter.new(Task.new(title: 'タイトル'))
        link = presenter.cancel_completion_link(nil)
        expect(link).to eq('')
      end
    end

    context '完了している場合' do

      let(:task) { create_task(author_id: user.id, title: 'タイトル', completed_at: :now, assignees: [user]) }

      it do
        view = double(:view)
        presenter = TaskPresenter.new(task)
        expect(view).to receive(:cancel_completion_task_url)
        expect(view).to receive(:link_to)
        link = presenter.cancel_completion_link(view)
      end
    end
  end
end
