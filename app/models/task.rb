class Task < ActiveRecord::Base
  has_one :task_description

  def write_description(description)
    self.build_task_description(content: description)
  end

  def description
    task_description.content
  end
end
