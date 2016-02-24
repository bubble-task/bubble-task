require 'rails_helper'

describe 'タスクの検索' do
  before do
    sign_in_as(user_a)
  end

  let(:user_a) { create_user_from_oauth_credential }
  let(:user_b) { create_user_from_oauth_credential }

  let(:completed_task) do
    create_task(
      author_id: user_a.id, title: '完了',
      completed_at: :now,
      tags: %w(ABC DEF EFG),
      assignees: [user_a, user_b]
    )
  end

  let(:uncompleted_task) do
    create_task(
      author_id: user_a.id, title: '未完了',
      tags: %w(DEF),
      assignees: [user_a, user_b],
      deadline: Time.current,
    )
  end

  context '遷移しただけで条件を指定しない場合' do
    before do
      completed_task
      uncompleted_task
    end

    let(:title_on_page) { first('.task-title') }

    it do
      visit search_path
      expect(title_on_page).to be_nil
    end
  end

  context 'デフォルト条件で検索する場合' do
    before do
      completed_task
      uncompleted_task
    end

    it do
      visit search_path
      click_button(I18n.t('search.index.actions.search'))
      tasks = all('.task-summary-primary')
      expect(tasks.size).to eq(2)
    end
  end

  describe '検索結果の表示' do
    context '完了タスク' do
      before do
        completed_task
        visit search_path
        click_button(I18n.t('search.index.actions.search'))
      end

      it do
        completed_on_page = first('.task-completed-on').text
        completed_on = TaskPresenter.new(completed_task).completed_on
        expect(completed_on_page).to eq(I18n.l(completed_on, format: :default))
      end

      it do
        cancel_completion = first('.cancel-completion')
        expect(cancel_completion).to_not be_nil
      end
    end

    context '未完了タスク' do
      before do
        uncompleted_task
        visit search_path
        click_button(I18n.t('search.index.actions.search'))
      end

      it do
        deadline_on_page = first('.task-completed-on').text
        deadline = uncompleted_task.deadline
        expect(deadline_on_page).to eq(I18n.l(deadline, format: :short))
      end

      it do
        cancel_completion = first('.cancel-completion')
        expect(cancel_completion).to be_nil
      end
    end
  end
end
