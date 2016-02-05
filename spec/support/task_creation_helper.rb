module TaskCreationHelper

  def create_task_from_ui(title:, description: '', tag_words: '', deadline: nil, with_sign_up: false)
    visit new_task_path
    create_task_from_ui_without_visit(title: title, description: description, tag_words: tag_words, deadline: deadline, with_sign_up: with_sign_up)
  end

  def update_task_from_ui(old_task, title: nil, description: nil, tag_words: nil, deadline: nil, disable_deadline: false)
    visit edit_task_path(old_task.id)
    update_task_from_ui_without_visit(title: title, description: description, tag_words: tag_words, deadline: deadline, disable_deadline: disable_deadline)
  end

  def create_task_from_ui_without_visit(title:, description: '', tag_words: '', deadline: nil, with_sign_up: false)
    fill_in_task_form(title: title, description: description, tag_words: tag_words, deadline: deadline, with_sign_up: with_sign_up)
    click_button I18n.t('helpers.submit.create')
  end

  def update_task_from_ui_without_visit(title: nil, description: nil, tag_words: nil, deadline: nil, disable_deadline: false)
    fill_in_task_form(title: title, description: description, tag_words: tag_words, deadline: deadline, disable_deadline: disable_deadline)
    click_button I18n.t('helpers.submit.update')
  end

  def fill_in_task_form(title: nil, description: nil, tag_words: nil, deadline: nil, disable_deadline: false, with_sign_up: false)
    find('#task_parameters_title')
    fill_in 'task_parameters[tag_words]', with: tag_words if tag_words
    fill_in 'task_parameters[title]', with: title if title
    fill_in 'task_parameters[description]', with: description if description
    fill_in 'task_parameters[deadline_date]', with: deadline.strftime('%Y/%m/%d') if deadline
    select deadline.strftime('%H'), from: 'task_parameters[deadline_hour]' if deadline
    select deadline.strftime('%M'), from: 'task_parameters[deadline_minutes]' if deadline
    find('#task_parameters_disable_deadline', visible: true).click if disable_deadline
    find('#task_parameters_with_sign_up_label', visible: false).click if with_sign_up
  end

  def create_task(author_id:, title:, description: nil, tags: [], completed_at: nil, assignees: [], deadline: nil)
    task = create_task_record(author_id: author_id, title: title, description: description, tags: tags, deadline: deadline)
    assignees.each do |user|
      TaskAssignment.new(task: task, assignee: user).run
    end
    return task unless completed_at
    make_task_completion(task, completed_at)
  end

  def create_task_record(author_id:, title:, description: nil, tags: [], deadline: nil)
    TaskFactory
      .create(author_id, title, description.to_s, tags, deadline)
      .tap(&:save!)
  end

  def make_task_completion(task, completed_at_param)
    completed_at = if completed_at_param.is_a?(String)
                     Time.zone.parse(completed_at_param)
                   else
                     Time.current
                   end
    task.tap do |t|
      t.complete(completed_at)
      t.save!
    end
  end
end
