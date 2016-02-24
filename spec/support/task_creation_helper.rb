require_relative './task_ui_helper'

module TaskCreationHelper
  include TaskUIHelper

  def create_task(author_id:, title:, description: nil, tags: [], completed_at: nil, assignees: [], deadline: nil)
    task = create(author_id: author_id, title: title, description: description, tags: tags, deadline: deadline)

    assignees.each do |user|
      TaskAssignment.new(task_id: task.id, assignee_id: user.id).run
    end

    return task unless completed_at

    make_task_completion(task, detect_completer_id(task), completed_at)
  end

  def create_personal_task(user_id:, title:, description: nil, completed_at: nil)
    task = TaskCreation.new(TaskCreationForm.new(title: title, description: description)).run(user_id)
    return task unless completed_at
    make_task_completion(task, user_id, completed_at)
  end

  def make_task_completion(task, completer_id, completed_at_param)
    completed_at = if completed_at_param.is_a?(String)
                     Time.zone.parse(completed_at_param)
                   else
                     Time.current
                   end
    task.tap do |t|
      t.complete(completer_id, completed_at)
      t.save!
    end
  end

  private

    def create(author_id:, title:, description: nil, tags: [], deadline: nil)
      form =
        TaskCreationForm.new(
          title: title,
          description: description.to_s,
          tag_words: tags.join(' '),
          deadline_date: deadline&.strftime('%Y/%m/%d'),
          deadline_hour: deadline&.strftime('%H'),
          deadline_minutes: deadline&.strftime('%M')
        )
      TaskCreation.new(form).run(author_id)
    end

    def detect_completer_id(task)
      return task.personal_task_owner.id if task.personal?
      return task.assignees.first.id if task.assignees.any?
      task.author_id
    end
end
