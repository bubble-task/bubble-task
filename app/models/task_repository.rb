module TaskRepository
  class << self

    def find_by_id(task_id)
      task_with_taggings.find(task_id)
    end

    def all_by_author_id(author_id)
      task_with_taggings.where(author_id: author_id).order(:id)
    end

    def all_by_tag(tag)
      Task.joins(:taggings).where(taggings: { tag: tag }).preload(:taggings)
    end

    private

      def task_with_taggings
        Task.includes(:taggings)
      end
  end
end
