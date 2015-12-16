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

    def all_completed_by_author_id(author_id, from_date_time: nil, to_date_time: nil)
      base = Task.includes(:completed_task, :taggings)
               .where(author_id: author_id)
               .where.not(completed_tasks: { id: nil })
      return base if from_date_time.nil? && to_date_time.nil?
      base = base.where('completed_tasks.completed_at >= ?', from_date_time) if from_date_time
      return base unless to_date_time
      base.where('completed_tasks.completed_at <= ?', to_date_time)
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
