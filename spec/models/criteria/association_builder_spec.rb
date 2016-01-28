require 'rails_helper'

class DummyRelation
  attr_reader :method_calls

  def initialize
    @method_calls = {}
  end

  def joins(args)
    @method_calls[:joins] = args
    self
  end

  def preload(*args)
    @method_calls[:preload] = args
    self
  end
end

describe Criteria::AssociationBuilder do
  context 'タグを指定' do
    context 'サインアップを問わない' do
      it do
        conditions = [Criteria::Conditions::Tags.create('ABC')]

        relation = DummyRelation.new
        builder = described_class.new(relation)
        builder.build(conditions)

        expect(relation.method_calls).to match(
          joins: 'INNER JOIN taggings ON taggings.task_id = tasks.id',
          preload: [:taggings],
        )
      end
    end

    context '自分がサインアップのみ' do
      it do
        conditions = [
          Criteria::Conditions::Assignee.create(123),
          Criteria::Conditions::Tags.create('ABC'),
        ]

        relation = DummyRelation.new
        builder = described_class.new(relation)
        builder.build(conditions)

        expect(relation.method_calls).to match(
          joins: 'OUTER JOIN assignments ON assignments.task_id = tasks.id INNER JOIN taggings ON taggings.task_id = tasks.id',
          preload: [:assignments, :taggings],
        )
      end
    end
  end
end
