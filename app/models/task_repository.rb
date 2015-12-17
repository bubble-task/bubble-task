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
        .order('tasks.id')
    end

    def all_completed_by_author_id(author_id, from_datetime: nil, to_datetime: nil)
      base = Task.includes(:completed_task, :taggings)
             .where(author_id: author_id)
             .where.not(completed_tasks: { id: nil })
             .order('completed_tasks.completed_at')
      return base if from_datetime.nil? && to_datetime.nil?
      base = base.where('completed_tasks.completed_at >= ?', from_datetime) if from_datetime
      return base unless to_datetime
      base.where('completed_tasks.completed_at <= ?', to_datetime)
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
  end
end
