class Task < ActiveRecord::Base
  include Removable

  NotDescribed = Class.new(StandardError)

  has_one :task_description, autosave: true
  has_many :taggings
  has_one :completed_task, autosave: true
  has_many :assignments
  has_many :assignees, through: :assignments, source: :user

  before_save do
    if task_description && task_description.removed?
      task_description.destroy
    end
    tag_collection.save(self)
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
    tag_collection.add(tags)
  end

  def tags
    tag_collection.tags
  end

  def remove_tags
    tag_collection.remove_all!
  end

  def complete
    self.build_completed_task(completed_at: Time.current)
  end

  def completed?
    completed_task
  end

  private

    def tag_collection
      @tags ||= TagCollection.create_from_taggings(taggings)
    end
end
