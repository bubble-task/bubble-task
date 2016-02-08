class TaskDeadline < ActiveRecord::Base
  include Removable

  def datetime
    return nil if removed?
    super
  end
end
