module Criteria
  class Achievement

    def initialize
      @conditions = []
      yield(self) if block_given?
    end

    def add_condition(condition)
      @conditions << condition
      @conditions.flatten!
    end

    def satisfy(relation)
      prepared_relation = @conditions.inject(RelationWrapper.new(relation)) { |r, c| c.prepare(r)  }.prepare
      satisfied_task_ids = @conditions.inject(prepared_relation.select('tasks.id')) { |r, c| c.satisfy(r) }
      Task
        .joins(:completed_task)
        .restrict_by_complated
        .where(id: satisfied_task_ids.to_a)
        .order('completed_tasks.completed_at')
      #default_relation = prepared_relation.restrict_by_complated.order('completed_tasks.completed_at')
    end
  end
end
