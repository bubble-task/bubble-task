module TaskPresenter
  class Uncompleted < SimpleDelegator

    def completion_checkbox_state
      nil
    end

    def timestamp
      return unless deadline
      I18n.l(deadline, format: :short)
    end

    def completion_form(view)
      return '<p></p>'.html_safe unless can_complete?(view.current_user.id)
      view.form_for(completion_command, url: view.complete_task_url(self), method: :put, remote: true) do |f|
        completion_form_fields(self)
      end
    end

    private

      def completion_command
        TaskCompletion.new(task_id: id)
      end
  end
end
