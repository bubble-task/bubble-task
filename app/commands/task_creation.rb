class TaskCreation
  include ActiveModel::Model

  attr_accessor :title, :description, :tag_words, :with_sign_up

  def errors
    task_parameters.errors
  end

  def run(user)
    return nil unless task_parameters.valid?
    task = TaskFactory.create(user.id, task_parameters.title, task_parameters.description, task_parameters.tags).tap(&:save)
    if with_sign_up.present?
      TaskAssignment.new(task: task, assignee: user).run
    end
    task
  end

  private

    def task_parameters
      @task_parameters ||= TaskParameters.new(title: title, description: description, tag_words: tag_words)
    end
end
