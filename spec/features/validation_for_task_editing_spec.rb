require 'rails_helper'

describe 'タスク編集時にバリデーションをかける' do
  before do
    sign_in_as(user)
  end

  let(:user) { create_user_from_oauth_credential }

  let(:task) { create_task(author_id: user.id, title: old_title, description: old_description, tags: old_tags, assignees: [user]) }
  let(:old_title) { '編集前のタイトル' }
  let(:old_description) { '編集前の説明' }
  let(:old_tags) { %w(タグ1 タグ2) }
  let(:old_tag_words) { old_tags.join(' ') }

  describe 'タイトル' do
    subject do
      update_task_from_ui(task, title: title)
      page
    end

    context '未入力' do
      let(:title) { '' }
      it { is_expected.to have_content 'タイトルを入力してください' }
    end

    context '最大文字数+1文字入力' do
      let(:title) { 'a' * 81 }
      it { is_expected.to have_content 'タイトルは80文字以内で入力してください' }
    end

    context '最大文字数入力' do
      let(:title) { 'a' * 80 }
      it { is_expected.to have_link title }
    end
  end

  describe '説明' do
    subject do
      update_task_from_ui(task, description: description)
      page
    end

    context '最大文字数+1文字入力' do
      let(:description) { 'a' * 5001 }

      it { is_expected.to have_content '説明は5000文字以内で入力してください' }
    end

    context '最大文字数入力' do
      let(:description) { 'a' * 5000 }
      it { is_expected.to have_link old_title }
    end
  end

  describe 'タグ' do
    let(:out_of_boundary_length) { 17 }
    let(:inside_of_boundary_length) { 16 }

    subject do
      update_task_from_ui(task, tag_words: tag_words)
      page
    end

    context '全て最大文字数以内で入力' do
      let(:tag_words) { "#{'a' * 8} #{'b' * 9}" }
      it { is_expected.to have_link(old_title) }
    end

    context '最大文字数+1を単独で入力' do
      let(:tag_words) { 'a' * out_of_boundary_length }
      it { is_expected.to have_content("タグ「#{tag_words}」は16文字以内で入力してください") }
    end

    context '最大文字数+1と最大文字数を一つずつ入力' do
      let(:invalid_tag) { 'b' * out_of_boundary_length }
      let(:tag_words) { "#{'a' * inside_of_boundary_length} #{invalid_tag}" }

      it { is_expected.to have_content("タグ「#{invalid_tag}」は16文字以内で入力してください") }
    end
  end

  describe '期限' do
    context '日付のみ入力' do
      it do
        update_task_from_ui(task, deadline: { date: Time.current.strftime('%Y/%m/%d') })
        expect(page).to have_link(old_title)
      end
    end

    context '日付と時間を入力' do
      it do
        update_task_from_ui(task, deadline: { date: Time.current.strftime('%Y/%m/%d'), hour: '01' })
        expect(page).to have_link(old_title)
      end
    end

    context '日付と分を入力' do
      it do
        update_task_from_ui(task, deadline: { date: Time.current.strftime('%Y/%m/%d'), minutes: '15' })
        expect(page).to have_content('時間を入力してください')
      end
    end

    context '時刻のみ入力' do
      it do
        update_task_from_ui(task, deadline: { minutes: '15' })
        expect(page).to have_content('期限を入力してください')
      end
    end

    context '時間のみ入力' do
      it do
        update_task_from_ui(task, deadline: { hour: '00' })
        expect(page).to have_content('期限を入力してください')
      end
    end

    context '分のみ入力' do
      it do
        update_task_from_ui(task, deadline: { minutes: '15' })
        expect(page).to have_content('期限を入力してください')
      end
    end
  end
end
