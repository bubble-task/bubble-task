class TaskAssignment

  def initialize(task: task, assignee: assignee)
    @task = task
    @assignee = assignee
  end

  def run
    new_assignment_list = @assignee.take_task(@task, current_assignment_list)
    new_assignment_list.save
  end

  private

    def current_assignment_list
      AssignmentRepository.for_user(@assignee.id)
    end
end
