class TaskFactory

  def self.create(author_id, title, description = nil, tags = [])
    task = Task.new(author_id: author_id, title: title)
    task.tagging(tags)
    return task unless description
    task.write_description(description)
    task
  end
end
