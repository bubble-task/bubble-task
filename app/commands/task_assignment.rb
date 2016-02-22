class TaskAssignment

  def initialize(task_id:, assignee_id:)
    @task_id = task_id
    @assignee_id = assignee_id
  end

  def run
    assignment_list = AssignmentRepository.for_task(@task_id)
    assignment_list.add_assignee(@assignee_id)
    assignment_list.save
  end
end
