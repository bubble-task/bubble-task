class TaskDescription < ActiveRecord::Base
  include RemovableAssociation

  def content
    return nil if removed?
    super
  end
end
