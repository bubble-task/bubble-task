module Criteria
  class CompletedTask

    def self.create(assignee_id: nil, from_date: nil, to_date: nil, tag_words: nil, completion_state: nil)
      new.tap do |c|
        c.add_condition(Criteria::Conditions::Assignee.create(assignee_id))
        c.add_condition(Criteria::Conditions::CompletedOnFrom.create(from_date))
        c.add_condition(Criteria::Conditions::CompletedOnTo.create(to_date))
        c.add_condition(Criteria::Conditions::Tags.create(tag_words))
        c.add_condition(Criteria::Conditions::Completed)
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
        AssociationBuilder.new(relation).build(@conditions) do |plans|
          unless plans.planned_inner_join?(:taggings)
            plans.add(taggings: :left_outer)
          end

          unless plans.planned_inner_join?(:completed_task)
            plans.add(completed_task: :left_outer)
          end
        end
      end

      def satisfy_relation(relation)
        @conditions.inject(relation) { |r, c| c.satisfy(r) }
      end
  end
end
