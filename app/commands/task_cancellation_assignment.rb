class TaskCancellationAssignment

  def initialize(task:, assignee:)
    @task = task
    @assignee = assignee
  end

  def run
    assignment_list = AssignmentRepository.for_task(@task.id)
    assignment_list.remove_assignee(@assignee.id)
    assignment_list.save
  end
end
