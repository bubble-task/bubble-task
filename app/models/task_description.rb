class TaskDescription < ActiveRecord::Base
  attr_reader :removed
  alias_method :removed?, :removed

  def remove!
    @removed = true
  end
end
