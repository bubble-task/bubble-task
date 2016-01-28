require 'rails_helper'

describe Criteria::AssociationBuilder do
  context 'タグを指定,サインアップを問わない' do
    it do
      conditions = [Criteria::Conditions::Tags.create('ABC')]

      relation = double(:relation)
      builder = described_class.new(relation)

      expect(relation)
        .to receive(:joins)
        .with('INNER JOIN taggings ON taggings.task_id = tasks.id')

      builder.build(conditions)
    end
  end

  context 'タグを指定,自分がサインアップのみ' do
    it do
      conditions = [
        Criteria::Conditions::Assignee.create(123),
        Criteria::Conditions::Tags.create('ABC'),
      ]

      relation = double(:relation)
      builder = described_class.new(relation)

      expect(relation)
        .to receive(:joins)
        .with('OUTER JOIN assignments ON assignments.task_id = tasks.id INNER JOIN taggings ON taggings.task_id = tasks.id')
      builder.build(conditions)
    end
  end
end
