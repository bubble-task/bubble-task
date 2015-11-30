class TaskDescription < ActiveRecord::Base
  attr_reader :removed

  def remove!
    @removed = true
  end

  def removed?
    @removed
  end
end
