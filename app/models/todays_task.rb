class TodaysTask < ActiveRecord::Base
  include Removable

  def ==(other)
    super || same_attributes?(other)
  end

  private

    def same_attributes?(other)
      self.task_id == other.task_id &&
        self.user_id == other.user_id
    end
end
