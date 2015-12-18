module TaskRestrictable
  extend ActiveSupport::Concern

  class_methods do

    def restrict_by_complated_after(datetime)
      where('completed_tasks.completed_at >= ?', datetime)
    end

    def restrict_by_complated_before(datetime)
      where('completed_tasks.completed_at <= ?', datetime)
    end

    def restrict_by_author(author_id)
      where(author_id: author_id)
    end
  end
end
