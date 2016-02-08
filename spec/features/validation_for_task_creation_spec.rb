require 'rails_helper'

describe 'タスク作成時にバリデーションをかける' do
  before do
    oauth_sign_in
  end

  let(:valid_title) { 'タスクのタイトル' }

  describe 'タイトル' do
    subject do
      create_task_from_ui(title: title)
      page
    end

    context '未入力' do
      let(:title) { '' }
      it { is_expected.to have_content 'タイトルを入力してください' }
    end

    context '最大文字数入力' do
      let(:title) { 'a' * 40 }
      it { is_expected.to have_link(title) }
    end

    context '最大文字数+1入力' do
      let(:title) { 'a' * 41 }
      it { is_expected.to have_content 'タイトルは40文字以内で入力してください' }
    end
  end

  describe '説明' do
    subject do
      create_task_from_ui(title: valid_title, description: description)
      page
    end

    context '最大文字数入力' do
      let(:description) { 'a' * 5000 }
      it { is_expected.to have_link(valid_title) }
    end

    context '最大文字数+1入力' do
      let(:description) { 'a' * 5001 }
      it { is_expected.to have_content '説明は5000文字以内で入力してください' }
    end
  end

  describe 'タグ' do
    let(:out_of_boundary_length) { 17 }
    let(:inside_of_boundary_length) { 16 }

    subject do
      create_task_from_ui(title: valid_title, tag_words: tag_words)
      page
    end

    context '全て最大文字数以内で入力' do
      let(:tag_words) { "#{'a' * 8} #{'b' * 9}" }
      it do
        subject
        visit tasks_path(tag: 'a' * 8)
        expect(page).to have_link('タスクのタイトル')
      end
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
        create_task_from_ui(title: title, deadline: { date: Time.current.strftime('%Y/%m/%d') })
        expect(page).to have_link(title)
      end
    end

    context '日付と時間を入力' do
      it do
        create_task_from_ui(title: title, deadline: { date: Time.current.strftime('%Y/%m/%d'), hour: '01' })
        expect(page).to have_link(title)
      end
    end

    context '日付と分を入力' do
      it do
        create_task_from_ui(title: title, deadline: { date: Time.current.strftime('%Y/%m/%d'), minutes: '15' })
        expect(page).to have_content('時間を入力してください')
      end
    end

    context '時刻のみ入力' do
      it do
        create_task_from_ui(title: title, deadline: { minutes: '15' })
        expect(page).to have_content('期限を入力してください')
      end
    end

    context '時間のみ入力' do
      it do
        create_task_from_ui(title: title, deadline: { hour: '00' })
        expect(page).to have_content('期限を入力してください')
      end
    end

    context '分のみ入力' do
      it do
        create_task_from_ui(title: title, deadline: { minutes: '15' })
        expect(page).to have_content('期限を入力してください')
      end
    end
  end
end
