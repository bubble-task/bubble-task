module Criteria
  class RelationPreparer

    def initialize(relation)
      @relation = relation
      @use_joins = false
      @associations = %i(completed_task assignments taggings)
    end

    def use_joins
      @use_joins = true
      self
    end

    def relation
      if @use_joins
        @relation
          .joins('LEFT OUTER JOIN completed_tasks ON completed_tasks.task_id = tasks.id LEFT OUTER JOIN assignments ON assignments.task_id = tasks.id INNER JOIN taggings ON taggings.task_id = tasks.id')
          .preload(*@associations)
      else
        @relation
          .includes(*@associations)
          .references(*@associations)
      end
    end
  end
end
