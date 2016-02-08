class TaskFactory

  def self.create(author_id, title, description = '', tags = [], deadline = nil)
    new(author_id, title).with do
      write_description(description)
      tagging_by(Array(tags).uniq)
      set_deadline(deadline)
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

  def tagging_by(tags)
    return if tags.empty?
    @task.tagging_by(tags)
  end

  def set_deadline(deadline)
    return unless deadline
    @task.set_deadline(deadline)
  end
end
