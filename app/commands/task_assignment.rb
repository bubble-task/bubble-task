class TaskAssignment

  def initialize(task:, assignee:)
    @task = task
    @assignee = assignee
  end

  def run
    assignment_list = AssignmentRepository.for_user(@assignee.id)
    assignment_list.add(@assignee.take_task(@task))
    assignment_list.save
  end
end
