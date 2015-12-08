class Task < ActiveRecord::Base
  include Removable

  NotDescribed = Class.new(StandardError)

  has_one :task_description, autosave: true
  has_many :taggings
  has_one :completed_task, autosave: true
  has_many :assignments
  has_many :users, through: :assignments

  before_save do
    if task_description && task_description.removed?
      task_description.destroy
    end
    taggings.select(&:removed?).each(&:destroy)
    destroy if removed?
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
    return unless task_description
    self.task_description.remove!
  end

  def description
    return nil unless task_description
    task_description.content
  end

  def tagging(tags)
    tags.each do |tag|
      self.taggings.build(tag: tag)
    end
  end

  def tags
    taggings.reject(&:removed?).map(&:tag)
  end

  def remove_tags
    taggings.each(&:remove!)
  end

  def complete
    self.build_completed_task(completed_at: Time.current)
  end

  def completed?
    completed_task
  end

  def assign(user_id)
    assignments.build(user_id: user_id)
  end

  def assignees
    assignments.map(&:user)
  end
end
