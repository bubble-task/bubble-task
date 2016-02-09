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

      if completion_state == 'any' || completion_state.nil?
        return Criteria::CompletedTask.create(
          assignee_id: assignee_id,
          from_date: from_date,
          to_date: to_date,
          tag_words: tag_words,
          completion_state: completion_state,
        )
      end
    end
  end
end
