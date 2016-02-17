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

    def restrict_by_deadline_before(datetime)
      where('task_deadlines.datetime <= ?', datetime)
    end

    def restrict_by_assignee(assignee_id)
      where(assignments: { user_id: assignee_id })
    end

    def restrict_by_tags(tags)
      where(taggings: { tag: tags })
        .group('tasks.id')
        .having("COUNT(tasks.id) = #{tags.size}")
    end

    def restrict_by_assignee_or_personal_task(user_id)
      where(
        '(personal_tasks.id IS NULL AND assignments.user_id = ?) OR personal_tasks.user_id = ?',
        user_id,
        user_id
      )
    end

    def restrict_by_public_task_or_searchers_personal_task(user_id)
      where('personal_tasks.id IS NULL OR personal_tasks.user_id = ?', user_id)
    end
  end
end
