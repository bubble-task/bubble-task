module TaskRepository
  class << self

    def find_by_id(task_id)
      task_with_taggings.find_by(id: task_id)
    end

    def all_by_author_id(author_id)
      task_with_taggings.where(author_id: author_id).order(:id)
    end

    def all_by_tag(tag)
      Task.includes(:completed_task, :taggings, { assignments: :user })
        .where(taggings: { tag: tag })
        .where(completed_tasks: { id: nil })
        .order(:id)
    end

    def all_uncompleted_by_author_id(author_id)
      Task.includes(:completed_task, :taggings, { assignments: :user })
        .where(author_id: author_id)
        .where(completed_tasks: { id: nil })
        .order(:id)
    end

    private

      def task_with_taggings
        Task.includes(:taggings, { assignments: :user })
      end
  end
end
