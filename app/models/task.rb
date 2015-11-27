class Task < ActiveRecord::Base
  NotDescribed = Class.new(StandardError)

  has_one :task_description, autosave: true
  has_many :taggings

  before_save do
    if task_description && task_description.will_remove?
      task_description.destroy
    end
  end

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

  def remove_description
    raise NotDescribed unless description
    self.task_description.mark_as_remove
  end

  def description
    return nil unless task_description
    return nil if task_description.will_remove?
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
