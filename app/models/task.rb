class Task < ActiveRecord::Base
  has_one :task_description, autosave: true
  has_many :taggings

  def retitle(title)
    self.title = title
  end

  def write_description(description)
    self.build_task_description(content: description)
  end

  def rewrite_description(description)
    return write_description(description) unless task_description
    self.task_description.content = description
  end

  def description
    task_description.content
  end

  def tagging(tags)
    tags.each do |tag|
      self.taggings.build(tag: tag)
    end
  end

  def tags
    taggings.map(&:tag)
  end
end
