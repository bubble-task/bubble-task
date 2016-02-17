module TaskRepository
  class << self

    def find_by_id(task_id)
      Task.includes(:taggings, { assignments: :user })
        .find_by(id: task_id)
    end

    def all_uncompleted_by_assignee(user_id)
      Task.includes(:completed_task, :taggings, { personal_task: :user }, { assignments: :user })
        .where('(assignments.user_id = ?) OR (personal_tasks.user_id = ?)', user_id, user_id)
        .where(completed_tasks: { id: nil })
        .order('tasks.id')
    end

    def all_by_tag(tag)
      Task
        .includes(:completed_task, { assignments: :user })
        .where(completed_tasks: { id: nil })
        .joins(:taggings)
        .where(taggings: { tag: tag })
        .preload(:taggings)
        .order('tasks.id')
    end

    def search_by_criteria(searcher_id, criteria)
      base_relation =
        Task
          .joins('LEFT OUTER JOIN personal_tasks ON personal_tasks.task_id = tasks.id')
          .where('personal_tasks.id IS NULL OR personal_tasks.user_id = ?', searcher_id)
      criteria.satisfy(base_relation)
      #criteria.satisfy(searcher_id, Task)
    end
  end
end
