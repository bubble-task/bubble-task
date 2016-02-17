class TaskCreation
  attr_reader :form

  def initialize(form)
    @form = form
  end

  def run(user)
    return false unless @form.valid?
    task = TaskFactory.create(user.id, @form.title, @form.description, @form.tags, @form.deadline)
    if @form.tags.empty?
      task.to_personal_task(user)
    end
    task.save!
    if @form.with_sign_up?
      TaskAssignment.new(task: task, assignee: user).run
    end
    task
  end
end
