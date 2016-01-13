class TaskCreation
  attr_reader :form

  def initialize(form)
    @form = form
  end

  def run(user)
    return false unless @form.valid?
    task = TaskFactory.create(user.id, @form.title, @form.description, @form.tags).tap(&:save)
    if @form.with_sign_up.present?
      TaskAssignment.new(task: task, assignee: user).run
    end
    task
  end
end
