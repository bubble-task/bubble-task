class Task < ActiveRecord::Base
  include Removable
  include TaskRestrictable

  NotDescribed = Class.new(StandardError)

  has_one :task_description, autosave: true
  has_many :taggings
  has_one :completed_task, autosave: true
  has_many :assignments, dependent: :destroy
  has_many :assignees, through: :assignments, source: :user
  has_one :task_deadline, autosave: true
  has_one :personal_task, autosave: true
  has_one :personal_task_owner, through: :personal_task, source: :user

  delegate :completed_at, to: :completed_task

  before_save do
    task_description&.apply_removed!
    tag_collection.associate_with_task(self)
    completed_task&.apply_removed!
    task_deadline&.apply_removed!
    apply_removed!
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
    self.task_description&.remove!
  end

  def description
    task_description&.content
  end

  def tagging_by(tags)
    tag_collection.remove_all!
    if tags.any?
      tag_collection.add(tags)
    else
      return if personal?
      self.build_personal_task(user_id: author_id)
    end
  end

  def tagging_by_user(tags, user)
    tag_collection.remove_all!
    if tags.any?
      tag_collection.add(tags)
      self.personal_task&.destroy
    else
      return if personal?
      self.build_personal_task(user_id: user.id)
      self.assignments.clear
    end
  end

  def tags
    tag_collection.to_a
  end

  def complete(completed_at = Time.current)
    self.build_completed_task(completed_at: completed_at)
  end

  def completed?
    return false unless completed_task
    !completed_task.removed?
  end

  def remove!
    tag_collection.remove_all!
    remove_description
    super
  end

  def cancel_completion
    completed_task.remove!
  end

  def set_deadline(deadline)
    self.build_task_deadline(datetime: deadline)
  end

  def reset_deadline(deadline)
    return set_deadline(deadline) unless task_deadline
    self.task_deadline.datetime = deadline
  end

  def deadline
    task_deadline&.datetime
  end

  def remove_deadline
    self.task_deadline&.remove!
  end

  def personal?
    personal_task
  end

  private

    def tag_collection
      @tag_collection ||= TagCollection.create_from_taggings(taggings)
    end
end
