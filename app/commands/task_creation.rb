class TaskCreation
  attr_reader :form

  def initialize(form)
    @form = form
  end

  def run(user_id)
    return false unless @form.valid?
    task = create_task(user_id)
    sign_up!(task.id, user_id)
    task
  end

  private

    def create_task(user_id)
      task = TaskFactory.create(user_id, @form.title, @form.description, @form.tags, @form.deadline)
      task = to_personal_task!(task, user_id)
      task.save!
      task
    end

    def to_personal_task!(task, user_id)
      return task if @form.tags.any?
      task.to_personal_task(user_id)
      task
    end

    def sign_up!(task_id, user_id)
      return unless @form.with_sign_up?
      TaskAssignment.new(task_id: task_id, assignee_id: user_id).run
    end
end
