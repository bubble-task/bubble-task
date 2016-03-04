module TaskRepository
  class << self

    def find_by_id(task_id)
      Task.includes(:taggings, { assignments: :user })
        .find_by(id: task_id)
    end

    def all_uncompleted_by_assignee(user_id)
      Task.includes(:completed_task, :taggings, :task_deadline, { personal_task: :user }, { assignments: :user })
        .where('(assignments.user_id = ?) OR (personal_tasks.user_id = ?)', user_id, user_id)
        .where(completed_tasks: { id: nil })
        .order('task_deadlines.datetime, tasks.id')
    end

    def all_by_tag(tag)
      Task
        .includes(:completed_task, :task_deadline, { assignments: :user })
        .where(completed_tasks: { id: nil })
        .joins(:taggings)
        .where(taggings: { tag: tag })
        .preload(:taggings)
        .order('task_deadlines.datetime, tasks.id')
    end

    def search_by_criteria(criteria)
      base_relation =
        Task
        .joins('LEFT OUTER JOIN personal_tasks ON personal_tasks.task_id = tasks.id')
        .preload(:personal_task)
      criteria.satisfy(base_relation)
    end
  end
end
