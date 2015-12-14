class Task < ActiveRecord::Base
  include Removable

  NotDescribed = Class.new(StandardError)

  has_one :task_description, { autosave: true }
  has_many :taggings
  has_one :completed_task, autosave: true
  has_many :assignments
  has_many :assignees, through: :assignments, source: :user

  before_save do
    task_description.try!(:apply_removed!)
    tag_collection.associate_with_task(self)
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

  def tagging_by(tags)
    tag_collection.remove_all!
    tag_collection.add(tags)
  end

  def tags
    tag_collection.to_a
  end

  def complete
    self.build_completed_task(completed_at: Time.current)
  end

  def completed?
    completed_task
  end

  private

    def tag_collection
      @tag_collection ||= TagCollection.create_from_taggings(taggings)
    end
end
