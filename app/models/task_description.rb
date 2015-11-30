class TaskDescription < ActiveRecord::Base
  attr_reader :will_remove

  def mark_as_remove
    @will_remove = true
  end

  def will_remove?
    will_remove
  end
end
