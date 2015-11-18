class TaskFactory

  def self.create(author_id, title, description = nil, tags = [])
    new(author_id, title).build do
      set_description(description)
      set_tags(tags)
    end
  end

  def initialize(author_id, title)
    @task = Task.new(author_id: author_id, title: title)
  end

  def build(&block)
    instance_eval(&block)
    @task
  end

  def set_description(description)
    return unless description
    @task.write_description(description)
  end

  def set_tags(tags)
    return if tags.empty?
    @task.tagging(tags)
  end
end
