require 'rails_helper'

describe 'GET /search' do
  before do
    request_sign_in_as(user)
  end

  let(:user) { create_user_from_oauth_credential }

  let(:completed_task) { create_task(author_id: user.id, title: '完了', completed_at: :now, assignees: [user]) }
  let(:uncompleted_task) { create_task(author_id: user.id, title: '未完了', assignees: [user]) }

  context '完了したタスクのみ検索する' do
    before do
      completed_task
      uncompleted_task
    end

    it do
      get search_path(c: { completion_state: 'completed' })
      tasks = assigns(:tasks)
      expect(tasks).to eq([completed_task])
    end
  end

  context '未完了タスクのみ検索する' do
    before do
      completed_task
      uncompleted_task
    end

    it do
      get search_path(c: { completion_state: 'uncompleted' })
      tasks = assigns(:tasks)
      expect(tasks).to eq([uncompleted_task])
    end
  end

  context '完了したタスクと未完了タスク両方検索する' do
    before do
      completed_task
      uncompleted_task
    end

    it do
      get search_path(c: { completion_state: 'any' })
      tasks = assigns(:tasks)
      expect(tasks).to eq([completed_task, uncompleted_task])
    end

    context 'タグを指定する' do
      before do
        task1
        task2
        task3
      end

      let(:task1) { create_task(author_id: user.id, title: '1', tags: ['ABC'], completed_at: :now, assignees: [user]) }
      let(:task2) { create_task(author_id: user.id, title: '2', tags: ['ABC'], assignees: [user]) }
      let(:task3) { create_task(author_id: user.id, title: '3', tags: ['XYZ'], assignees: [user]) }

      it do
        get search_path(c: { completion_state: 'any', tag_words: 'ABC' })
        tasks = assigns(:tasks)
        expect(tasks).to eq([task1, task2])
      end
    end
  end
end
