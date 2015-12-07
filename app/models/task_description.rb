class TaskDescription < ActiveRecord::Base
  include Removable

  def content
    return nil if removed?
    super
  end
end
