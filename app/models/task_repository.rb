module TaskRepository
  class << self

    def find_by_id(task_id)
      Task.includes(:taggings, { assignments: :user })
        .find_by(id: task_id)
    end

    def all_uncompleted_by_author_id(author_id)
      Task.includes(:completed_task, :taggings, { assignments: :user })
        .where(author_id: author_id)
        .where(completed_tasks: { id: nil })
        .order('tasks.id, taggings.id')
    end

    def all_completed_by_author_id(author_id, from_date: nil, to_date: nil)
      base = Task.includes(:completed_task, :taggings)
               .where(author_id: author_id)
               .where.not(completed_tasks: { id: nil })
      return base if from_date.nil? && to_date.nil?
      return base.where('completed_tasks.completed_at >= ?', from_date) if from_date
      return base.where('completed_tasks.completed_at <= ?', to_date) if to_date
    end

    def all_by_tag(tag)
      Task
        .includes(:completed_task, { assignments: :user })
        .where(completed_tasks: { id: nil })
        .joins(:taggings)
        .where(taggings: { tag: tag })
        .preload(:taggings)
        .order('tasks.id, taggings.id')
    end
  end
end
