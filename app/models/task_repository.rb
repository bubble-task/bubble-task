module TaskRepository
  class << self

    def find_by_id(task_id)
      Task.includes(:taggings, { assignments: :user })
        .find_by(id: task_id)
    end

    def all_uncompleted_by_assignee(user_id)
      Task.includes(:completed_task, :taggings, { assignments: :user })
        .where('(assignments.user_id = ? AND taggings.id IS NOT NULL) OR (tasks.author_id = ? AND taggings.id IS NULL)', user_id, user_id)
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

    def search_by_criteria(criteria)
      criteria.satisfy(Task.includes(:completed_task, :taggings))
    end
  end
end
