class TaskFactory

  def self.create(author_id, title, description = '', tags = [])
    new(author_id, title).with do
      write_description(description)
      tagging(tags.uniq)
    end
  end

  def initialize(author_id, title)
    @task = Task.new(author_id: author_id, title: title)
  end

  def with(&block)
    instance_eval(&block)
    @task
  end

  def write_description(description)
    return if description.blank?
    @task.write_description(description)
  end

  def tagging(tags)
    return if tags.empty?
    @task.tagging(tags)
  end
end
