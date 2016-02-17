class TaskCreation
  attr_reader :form

  def initialize(form)
    @form = form
  end

  def run(user)
    return false unless @form.valid?
    task = create_task(user)
    sign_up!(task, user)
    task
  end

  private

    def create_task(user)
      task = TaskFactory.create(user.id, @form.title, @form.description, @form.tags, @form.deadline)
      task = to_personal_task!(task, user)
      task.save!
      task
    end

    def to_personal_task!(task, user)
      return task if @form.tags.any?
      task.to_personal_task(user)
      task
    end

    def sign_up!(task, user)
      return unless @form.with_sign_up?
      TaskAssignment.new(task: task, assignee: user).run
    end
end
