class Assignment < ActiveRecord::Base
  belongs_to :task
  belongs_to :user

  def ==(other)
    super || same_attributes?(other)
  end

  private

    def same_attributes?(other)
      self.task_id == other.task_id &&
        self.user_id == other.user_id
    end
end
