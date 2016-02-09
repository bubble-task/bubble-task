module Criteria
  class Task

    def self.create(assignee_id: nil, from_date: nil, to_date: nil, tag_words: nil, completion_state: nil)
      if completion_state == 'completed'
        return Criteria::CompletedTask.create(
          assignee_id: assignee_id,
          from_date: from_date,
          to_date: to_date,
          tag_words: tag_words,
          completion_state: completion_state,
        )
      end

      if completion_state == 'uncompleted'
        return Criteria::UncompletedTask.create(
          assignee_id: assignee_id,
          from_date: from_date,
          to_date: to_date,
          tag_words: tag_words,
          completion_state: completion_state,
        )
      end

      new.tap do |c|
        c.add_condition(Criteria::Conditions::Assignee.create(assignee_id))
        case completion_state
        when 'any'
          c.add_condition(Criteria::Conditions::CompletedOnFrom.create(from_date))
          c.add_condition(Criteria::Conditions::CompletedOnTo.create(to_date))
        end
        c.add_condition(Criteria::Conditions::Tags.create(tag_words))
        c.add_condition(Criteria::Conditions::Completion.create(completion_state))
      end
    end

    def initialize
      @conditions = []
    end

    def add_condition(condition)
      @conditions << condition
    end

    def satisfy(relation)
      finalize_conditions
      prepared_relation = prepare_relation(relation)
      satisfy_relation(prepared_relation).uniq.order(:id)
    end

    private

      def finalize_conditions
        @conditions.flatten!
      end

      def prepare_relation(relation)
        AssociationBuilder.new(relation).build(@conditions)
      end

      def satisfy_relation(relation)
        @conditions.inject(relation) { |r, c| c.satisfy(r) }
      end
  end
end
