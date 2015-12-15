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
        .order(:id)
    end

    def all_by_tag(tag)
      Task
        .joins(:taggings)
        .where(taggings: { tag: tag })
        .preload(:taggings)
        .includes(:completed_task, { assignments: :user })
        .where(completed_tasks: { id: nil })
        .order(:id)
    end
  end
end
