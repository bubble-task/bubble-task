class TaskAssignment

  def initialize(task: task, assignee: assignee)
    @task = task
    @assignee = assignee
  end

  def run
    assignment_list = AssignmentRepository.for_user(@assignee.id)
    assignment = @assignee.take_task(@task, assignment_list)
    assignment.save
  end
end
