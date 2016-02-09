module TaskRestrictable
  extend ActiveSupport::Concern

  class_methods do
    def restrict_by_completed
      where.not(completed_tasks: { id: nil })
    end

    def restrict_by_uncompleted
      where(completed_tasks: { id: nil })
    end

    def restrict_by_completed_after(datetime)
      where('completed_tasks.completed_at >= ?', datetime)
    end

    def restrict_by_completed_before(datetime)
      where('completed_tasks.completed_at <= ?', datetime)
    end

    def restrict_by_deadline_after(datetime)
      where('task_deadlines.datetime >= ?', datetime)
    end

    def restrict_by_assignee(assignee_id)
      where(assignments: { user_id: assignee_id })
    end

    def restrict_by_tags(tags)
      where(taggings: { tag: tags })
        .group('tasks.id')
        .having("COUNT(tasks.id) = #{tags.size}")
    end
  end
end
