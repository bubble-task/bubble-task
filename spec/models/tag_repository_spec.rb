require 'rails_helper'

describe TagRepository do
  it do
    TaskFactory.create(1, 'タスクのタイトル', nil, %w(タグ1)).tap(&:save)
    TaskFactory.create(1, 'タスクのタイトル', nil, %w(タグ2)).tap(&:save)
    expect(described_class.index).to eq(%w(タグ1 タグ2))
  end

  it do
    TaskFactory.create(1, 'タスクのタイトル', nil, %w(タグ3)).tap(&:save)
    TaskFactory.create(1, 'タスクのタイトル', nil, %w(タグ4)).tap(&:save)
    TaskFactory.create(1, 'タスクのタイトル', nil, %w(タグ3)).tap(&:save)
    expect(described_class.index).to eq(%w(タグ3 タグ4))
  end

  it do
    TaskFactory.create(1, 'タスクのタイトル', nil, %w(タグB)).tap(&:save)
    TaskFactory.create(1, 'タスクのタイトル', nil, %w(タグC)).tap(&:save)
    TaskFactory.create(1, 'タスクのタイトル', nil, %w(タグA)).tap(&:save)
    expect(described_class.index).to eq(%w(タグA タグB タグC))
  end
end
