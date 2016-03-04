module TaskPresenter
  class Completed < SimpleDelegator

    def cancellation_completion_command
      TaskCancellationCompletion.new(task_id: id)
    end

    def completed_on
      completed_task.completed_at.to_date
    end

    def completion_checkbox_state
      %(checked="checked").html_safe
    end
  end
end
