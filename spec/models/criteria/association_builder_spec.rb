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

    context 'タグを指定,サインアップを問わない,完了状態を問わない' do
      let(:conditions) do
        [
          Criteria::Conditions::Assignee.create(nil),
          Criteria::Conditions::CompletedOnFrom.create(nil),
          Criteria::Conditions::CompletedOnTo.create(nil),
          Criteria::Conditions::Tags.create('ABC'),
          Criteria::Conditions::Completion.create('any'),
        ]
      end

      it do
        expect(relation.method_calls).to match(
          joins: 'INNER JOIN taggings ON taggings.task_id = tasks.id LEFT OUTER JOIN completed_tasks ON completed_tasks.task_id = tasks.id',
          preload: [:taggings, :completed_task],
        )
      end
    end

    context '期間を指定,タグを指定,自分がサインアップのみ' do
      let(:conditions) do
        [
          Criteria::Conditions::Assignee.create(123),
          Criteria::Conditions::CompletedOnFrom.create(1.days.ago),
          Criteria::Conditions::CompletedOnTo.create(Time.current),
          Criteria::Conditions::Tags.create('ABC'),
          Criteria::Conditions::Completion.create('completed'),
        ]
      end

      it do
        expect(relation.method_calls).to match(
          joins: 'INNER JOIN assignments ON assignments.task_id = tasks.id INNER JOIN completed_tasks ON completed_tasks.task_id = tasks.id INNER JOIN taggings ON taggings.task_id = tasks.id',
          preload: [:assignments, :completed_task, :taggings],
        )
      end
    end

    context '期間を指定,未完了のみ' do
      let(:conditions) do
        [
          Criteria::Conditions::Assignee.create(nil),
          Criteria::Conditions::CompletedOnFrom.create(1.days.ago),
          Criteria::Conditions::CompletedOnTo.create(Time.current),
          Criteria::Conditions::Tags.create(''),
          Criteria::Conditions::Completion.create('uncompleted'),
        ]
      end

      it do
        expect(relation.method_calls).to match(
          joins: 'INNER JOIN completed_tasks ON completed_tasks.task_id = tasks.id LEFT OUTER JOIN taggings ON taggings.task_id = tasks.id',
          preload: [:completed_task, :taggings],
        )
      end
    end

    context '条件なし' do
      let(:conditions) do
        [
          Criteria::Conditions::Assignee.create(nil),
          Criteria::Conditions::CompletedOnFrom.create(nil),
          Criteria::Conditions::CompletedOnTo.create(nil),
          Criteria::Conditions::Tags.create(''),
          Criteria::Conditions::Completion.create('any'),
        ]
      end

      it do
        expect(relation.method_calls).to match(
          joins: 'LEFT OUTER JOIN completed_tasks ON completed_tasks.task_id = tasks.id LEFT OUTER JOIN taggings ON taggings.task_id = tasks.id',
          preload: [:completed_task, :taggings],
        )
      end
    end
  end
end
