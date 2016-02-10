module Criteria
  class Task

    def self.create(assignee_id: nil, from_date: nil, to_date: nil, tag_words: nil, completion_state: nil)
      if completion_state == 'completed'
        c = Criteria::CompletedTask.create(
          assignee_id: assignee_id,
          from_date: from_date,
          to_date: to_date,
          tag_words: tag_words,
          completion_state: completion_state,
        )
        return new(c)
      end

      if completion_state == 'uncompleted'
        c = Criteria::UncompletedTask.create(
          assignee_id: assignee_id,
          from_date: from_date,
          to_date: to_date,
          tag_words: tag_words,
          completion_state: completion_state,
        )
        return new(c)
      end

      if completion_state == 'any' || completion_state.nil?
        c1 = Criteria::CompletedTask.create(
          assignee_id: assignee_id,
          from_date: from_date,
          to_date: to_date,
          tag_words: tag_words,
          completion_state: completion_state,
        )
        c2 = Criteria::UncompletedTask.create(
          assignee_id: assignee_id,
          from_date: from_date,
          to_date: to_date,
          tag_words: tag_words,
          completion_state: completion_state,
        )
        return new(c1, c2)
      end
    end

    def initialize(*criterias)
      @criterias = criterias
    end

    def satisfy(relation)
      results =
        @criterias.each_with_object([]) do |c, r|
          r << c.satisfy(relation)
        end
      results.inject(:+).uniq
    end
  end
end
