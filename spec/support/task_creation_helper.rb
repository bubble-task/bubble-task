module TaskCreationHelper

  def create_task_from_ui(title:, description: '', tag_words: '')
    visit new_task_path
    fill_in 'task_parameters[tag_words]', with: tag_words
    fill_in 'task_parameters[title]', with: title
    fill_in 'task_parameters[description]', with: description
    click_button '作成する'
  end

  def update_task_from_ui(old_task, title: nil, description: nil, tag_words: nil)
    visit edit_task_path(old_task.id)
    fill_in 'task_parameters[tag_words]', with: tag_words if tag_words
    fill_in 'task_parameters[title]', with: title if title
    fill_in 'task_parameters[description]', with: description if description
    click_button I18n.t('helpers.submit.update')
  end

  def create_task(author_id:, title:, description: nil, tags: [], completed: false, completed_at: nil)
    create_task_record(author_id: author_id, title: title, description: description, tags: tags)
  end

  def create_task_record(author_id:, title:, description: nil, tags: [])
    TaskFactory
      .create(author_id, title, description.to_s, tags)
      .tap(&:save!)
  end
end
