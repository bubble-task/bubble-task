class Assignment < ActiveRecord::Base
  belongs_to :task
  belongs_to :user

  def associated?(user)
    user_id == user.id
  end

  def has_association?(user, task)
    user_id == user.id && task_id == task.id
  end

  def ==(other)
    super || same_attributes?(other)
  end

  private

    def same_attributes?(other)
      self.user_id == other.task_id &&
        self.task_id == other.task_id
    end
end
