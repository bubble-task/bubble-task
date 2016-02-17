module Criteria
  module CompletedTask

    def self.create(searcher_id, assignee_id: nil, from_date: nil, to_date: nil, tag_words: nil, completion_state: nil)
      AbstractCriteria.new.tap do |c|
        c.add_condition(Conditions::Assignee.create(searcher_id, assignee_id))
        c.add_condition(Conditions::CompletedOnFrom.create(from_date))
        c.add_condition(Conditions::CompletedOnTo.create(to_date))
        c.add_condition(Conditions::Tags.create(tag_words))
        c.add_condition(Conditions::Completed)
        c.set_preparation do |plans|
          unless plans.planned_inner_join?(:taggings)
            plans.add(taggings: :left_outer)
          end
        end
      end
    end
  end
end
