class TaskCancellationAssignment

  def initialize(task:, assignee:)
    @task = task
    @assignee = assignee
  end

  def run
    current_assignment_list = AssignmentRepository.for_user(@assignee.id)
    new_assignment_list = @assignee.abandon_task(@task, current_assignment_list)
    @task.assignments.destroy_all
    new_assignment_list.save
  end
end
