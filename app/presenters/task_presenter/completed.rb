module TaskPresenter
  class Completed < SimpleDelegator

    def timestamp
      I18n.l(completed_on, format: :default)
    end

    def completion_checkbox_state
      %(checked="checked").html_safe
    end

    def completion_form(view)
      view.form_for(cancellation_completion_command, url: view.cancel_completion_task_url(self), method: :put, remote: true) do |f|
        completion_form_fields(self)
      end
    end

    private

      def completed_on
        completed_task.completed_at.to_date
      end

      def cancellation_completion_command
        TaskCancellationCompletion.new(task_id: id)
      end
  end
end
