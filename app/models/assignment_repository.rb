module AssignmentRepository
  module_function

  def for_task(task_id)
    AssignmentList.new(task_id, Assignment.where(task_id: task_id))
  end
end
