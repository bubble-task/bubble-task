module TaskCreationHelper

  def create_task_from_ui(title:, description: '', tag_words: '', with_sign_up: false)
    visit new_task_path
    create_task_from_ui_without_visit(title: title, description: description, tag_words: tag_words, with_sign_up: with_sign_up)
  end

  def update_task_from_ui(old_task, title: nil, description: nil, tag_words: nil)
    visit edit_task_path(old_task.id)
    update_task_from_ui_without_visit(title: title, description: description, tag_words: tag_words)
  end

  def create_task_from_ui_without_visit(title:, description: '', tag_words: '', with_sign_up: false)
    fill_in_task_form(title: title, description: description, tag_words: tag_words, with_sign_up: with_sign_up)
    click_button I18n.t('helpers.submit.create')
  end

  def update_task_from_ui_without_visit(title: nil, description: nil, tag_words: nil)
    fill_in_task_form(title: title, description: description, tag_words: tag_words)
    click_button I18n.t('helpers.submit.update')
  end

  def fill_in_task_form(title: nil, description: nil, tag_words: nil, with_sign_up: false)
    fill_in 'task_parameters[tag_words]', with: tag_words if tag_words
    fill_in 'task_parameters[title]', with: title if title
    fill_in 'task_parameters[description]', with: description if description
    find('#task_parameters_with_sign_up_label', visible: false).click if with_sign_up
  end

  def create_task(author_id:, title:, description: nil, tags: [], completed_at: nil, assignees: [])
    task = create_task_record(author_id: author_id, title: title, description: description, tags: tags)
    assignees.each do |user|
      TaskAssignment.new(task: task, assignee: user).run
    end
    return task unless completed_at
    make_task_completion(task, completed_at)
  end

  def create_task_record(author_id:, title:, description: nil, tags: [])
    TaskFactory
      .create(author_id, title, description.to_s, tags)
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
