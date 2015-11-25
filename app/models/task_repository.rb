module TaskRepository
  module_function

  def all_by_tag(tag)
    Task.includes(:taggings).where(taggings: { tag: tag })
  end
end
