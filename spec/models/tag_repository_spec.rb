require 'rails_helper'

describe TagRepository do

  it do
    TaskFactory.create(1, 'タスクのタイトル', nil, %w(タグ1))
    TaskFactory.create(1, 'タスクのタイトル', nil, %w(タグ2))
    expect(described_class.index).to eq(%w(タグ1 タグ2))
  end
end
