class TaskDescription < ActiveRecord::Base

  def mark_as_remove
    @will_remove = true
  end

  def will_remove?
    @will_remove
  end
end
