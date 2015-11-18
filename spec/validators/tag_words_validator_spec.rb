require 'rails_helper'

class RecordSpy
  extend ActiveModel::Naming

  attr_reader :errors

  def initialize
    @errors = ActiveModel::Errors.new(self)
  end
end

describe TagWordsValidator do
  let(:validator) { described_class.new({attributes: 1}) }
  let(:record) { TaskCreation.new }

  it do
    validator.validate_each(record, :tag_words, 'a' * 16)
    expect(record.errors).to be_empty
  end

  it do
    validator.validate_each(record, :tag_words, "#{'a' * 16} #{'b' * 17}")
    expect(record.errors.messages).to eq({tag_words: ["「#{'b' * 17}」は16文字以内で入力してください"]})
  end

  it do
    validator.validate_each(record, :tag_words, "#{'a' * 17} #{'b' * 17}")
    expect(record.errors.messages).to eq({tag_words: ["「#{'a' * 17}」は16文字以内で入力してください", "「#{'b' * 17}」は16文字以内で入力してください"]})
  end
end
