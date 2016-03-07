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

    def completion_form(view)
      view.form_for(cancellation_completion_command, url: view.cancel_completion_task_url(self), method: :put, remote: true) do |f|
        fields = ''
        fields << %(<input type="checkbox" id="task_#{id}_completion_check" class="task_completion" #{completion_checkbox_state} />)
        fields << %(<label id="task_#{id}_completion_mark" for="task_#{id}_completion_check"></label>)
        fields.html_safe
      end
    end
  end
end
