module TaskRepository
  module_function

  def find_by_id(task_id)
    Task.includes(:taggings).find(task_id)
  end

  def all_by_tag(tag)
    Task.joins(:taggings).where(taggings: { tag: tag }).preload(:taggings)
  end
end
