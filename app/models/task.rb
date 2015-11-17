class Task < ActiveRecord::Base
  has_one :task_description

  def self.by_author(author)
    where(author_id: author.id)
  end

  def write_description(description)
    self.build_task_description(content: description)
  end

  def description
    task_description.content
  end
end
