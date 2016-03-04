require 'rails_helper'

describe 'タスクの並び順' do
  include TaskElementHelper

  before do
    sign_in_as(user)
  end

  let(:user) { create_user_from_oauth_credential }
  let(:create_task_for_user_b) { create_task(author_id: user_b.id, title: 'ユーザBのタスク') }

  context 'ホーム画面' do
    it do
      task_without_deadline4 = create_task(author_id: user.id, title: '期限なしタスク4')
      task_without_deadline5 = create_task(author_id: user.id, title: '期限なしタスク5')
      task_without_deadline6 = create_task(author_id: user.id, title: '期限なしタスク6')
      task_with_deadline3 = create_task(author_id: user.id, title: '期限付きタスク3', deadline: Time.zone.parse('2016-01-03'))
      task_with_deadline1 = create_task(author_id: user.id, title: '期限付きタスク1', deadline: Time.zone.parse('2016-01-01'))
      task_with_deadline2 = create_task(author_id: user.id, title: '期限付きタスク2', deadline: Time.zone.parse('2016-01-02'))
      visit root_path
      expect(all('.task-summary').map { |t| t[:id] }).to eq([
        task_css_id(task_with_deadline1.id),
        task_css_id(task_with_deadline2.id),
        task_css_id(task_with_deadline3.id),
        task_css_id(task_without_deadline4.id),
        task_css_id(task_without_deadline5.id),
        task_css_id(task_without_deadline6.id),
      ])
    end
  end
end
