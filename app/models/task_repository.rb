module TaskRepository
  module_function

  def all_by_tag(tag)
    Task.joins(:taggings).where(taggings: { tag: tag }).preload(:taggings)
  end
end
