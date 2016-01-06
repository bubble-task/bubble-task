module TaskRestrictable
  extend ActiveSupport::Concern

  class_methods do
    def restrict_by_complated
      where.not(completed_tasks: { id: nil })
    end

    def restrict_by_complated_after(datetime)
      where('completed_tasks.completed_at >= ?', datetime)
    end

    def restrict_by_complated_before(datetime)
      where('completed_tasks.completed_at <= ?', datetime)
    end

    def restrict_by_assignee(assignee_id)
      where('assignments.user_id = ?', assignee_id)
    end

    def restrict_by_tag(tag)
      where(taggings: { tag: tag })
    end
  end
end
