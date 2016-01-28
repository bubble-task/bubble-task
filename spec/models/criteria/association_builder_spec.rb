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
  describe '#build' do
    before do
      builder.build(conditions)
    end

    let(:builder) { described_class.new(relation) }
    let(:relation) { DummyRelation.new }

    context 'タグを指定,サインアップを問わない' do
      let(:conditions) { [Criteria::Conditions::Tags.create('ABC')] }

      it do
        expect(relation.method_calls).to match(
          joins: 'INNER JOIN taggings ON taggings.task_id = tasks.id',
          preload: [:taggings],
        )
      end
    end

    context 'タグを指定,自分がサインアップのみ' do
      let(:conditions) do
        [
          Criteria::Conditions::Assignee.create(123),
          Criteria::Conditions::Tags.create('ABC'),
        ]
      end

      it do
        expect(relation.method_calls).to match(
          joins: 'OUTER JOIN assignments ON assignments.task_id = tasks.id INNER JOIN taggings ON taggings.task_id = tasks.id',
          preload: [:assignments, :taggings],
        )
      end
    end
  end
end
