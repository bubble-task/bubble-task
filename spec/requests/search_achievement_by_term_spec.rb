require 'rails_helper'

describe 'GET /achievements' do
  before do
    user
    request_oauth_sign_in(auth_hash: auth_hash)
    expected_tasks
    unexpected_tasks
  end

  let(:user) { create_user_from_oauth_credential(auth_hash) }
  let(:auth_hash) { generate_auth_hash }

  let(:uncompleted_task) { [create_task(author_id: user.id, title: '未完了タスク')] }

  context '期間を指定しない' do
    let(:unexpected_tasks) { [uncompleted_task] }

    let(:expected_tasks) do
      [
        create_task(author_id: user.id, title: '完了A').tap do |t|
          TaskCompletion.new(task_id: t.id).run
        end
      ]
    end

    it do
      get achievements_path(achievement_search: { from_date: nil, to_date: nil })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end

  context '期間の絞り込みの開始日を指定' do
    let(:unexpected_tasks) do
      [
        uncompleted_task,
        create_task(author_id: user.id, title: 'b').tap do |t|
          t.complete(Time.zone.parse('2015-11-30'))
          t.save
        end
      ]
    end

    let(:expected_tasks) do
      [
        create_task(author_id: user.id, title: 'c').tap do |t|
          t.complete(Time.zone.parse('2015-12-01'))
          t.save
        end
      ]
    end

    it do
      get achievements_path(achievement_search: { from_date: '2015-12-01', to_date: nil })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end

  context '期間の絞り込みの終了日を指定' do
    let(:unexpected_tasks) do
      [
        uncompleted_task,
        create_task(author_id: user.id, title: 'b').tap do |t|
          t.complete(Time.zone.parse('2015-12-01'))
          t.save
        end
      ]
    end

    let(:expected_tasks) do
      [
        create_task(author_id: user.id, title: 'c').tap do |t|
          t.complete(Time.zone.parse('2015-11-30 12:00'))
          t.save
        end
      ]
    end

    it do
      get achievements_path(achievement_search: { from_date: nil, to_date: '2015-11-30' })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end

  context '期間の絞り込みの開始日と終了日を指定' do
    let(:unexpected_tasks) do
      [
        uncompleted_task,
        create_task(author_id: user.id, title: 'b').tap do |t|
          t.complete(Time.zone.parse('2015-11-30'))
          t.save
        end,
        create_task(author_id: user.id, title: 'c').tap do |t|
          t.complete(Time.zone.parse('2016-01-01'))
          t.save
        end
      ]
    end

    let(:expected_tasks) do
      [
        create_task(author_id: user.id, title: 'd').tap do |t|
          t.complete(Time.zone.parse('2015-12-01'))
          t.save
        end,
        create_task(author_id: user.id, title: 'e').tap do |t|
          t.complete(Time.zone.parse('2015-12-31'))
          t.save
        end
      ]
    end

    it do
      get achievements_path(achievement_search: { from_date: '2015-12-01', to_date: '2015-12-31' })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end
end
