module TaskPresenter
  class Base < SimpleDelegator

    def tags
      TagPresenter.create(__getobj__.tags)
    end

    def completion_form_fields(task)
      fields = ''
      fields << %(<input type="checkbox" id="#{completion_checkbox_id(task.id)}" class="task_completion" #{task.completion_checkbox_state} />)
      fields << %(<label id="task_#{task.id}_completion_mark" for="#{completion_checkbox_id(task.id)}"></label>)
      fields.html_safe
    end

    def signed_up?(user)
      assignees.include?(user)
    end

    private

     def completion_checkbox_id(task_id)
       "task_#{task_id}_completion_check"
     end
  end
end
