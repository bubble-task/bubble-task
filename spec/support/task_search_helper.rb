module TaskSearchHelper

  def assigned_task_ids
    assigns(:tasks).map(&:id)
  end
end
