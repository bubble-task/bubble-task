class TaskCancellationAssignment

  def initialize(task_id:, assignee_id:)
    @task_id = task_id
    @assignee_id = assignee_id
  end

  def run
    assignment_list = AssignmentRepository.for_task(@task_id)
    assignment_list.remove_assignee(@assignee_id)
    assignment_list.save
  end
end
