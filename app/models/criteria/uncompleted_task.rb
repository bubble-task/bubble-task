module Criteria
  module UncompletedTask

    def self.create(searcher_id, assignee_id: nil, from_date: nil, to_date: nil, tag_words: nil, completion_state: nil)
      AbstractCriteria.new.tap do |c|
        c.add_condition(Conditions::Assignee.create(searcher_id, assignee_id))
        c.add_condition(Conditions::DeadlineFrom.create(from_date))
        c.add_condition(Conditions::DeadlineTo.create(to_date))
        c.add_condition(Conditions::Tags.create(tag_words))
        c.add_condition(Conditions::Uncompleted)

        c.set_preparation do |plans|
          unless plans.planned_inner_join?(:taggings)
            plans.add(taggings: :left_outer)
          end
          unless plans.planned_left_outer_join?(:task_deadline)
            plans.add(task_deadline: :left_outer)
          end
        end

        c.set_sorter do |result_set|
          with_deadline = result_set.select(&:deadline).sort_by { |r| r.deadline }
          without_deadline = (result_set - with_deadline).sort_by { |r| r.id }
          with_deadline + without_deadline
        end
      end
    end
  end
end
