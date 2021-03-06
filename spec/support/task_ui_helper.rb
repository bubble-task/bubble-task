module TaskUIHelper

  def create_task_from_ui(title:, description: '', tag_words: '', deadline: nil, with_sign_up: false)
    visit new_task_path
    create_task_from_ui_without_visit(title: title, description: description, tag_words: tag_words, deadline: deadline, with_sign_up: with_sign_up)
  end

  def update_task_from_ui(old_task, title: nil, description: nil, tag_words: nil, deadline: nil)
    visit edit_task_path(old_task.id)
    update_task_from_ui_without_visit(title: title, description: description, tag_words: tag_words, deadline: deadline)
  end

  def create_task_from_ui_without_visit(title:, description: '', tag_words: '', deadline: nil, with_sign_up: false)
    fill_in_task_form(title: title, description: description, tag_words: tag_words, deadline: deadline, with_sign_up: with_sign_up)
    click_button I18n.t('helpers.submit.create')
  end

  def update_task_from_ui_without_visit(title: nil, description: nil, tag_words: nil, deadline: nil)
    fill_in_task_form(title: title, description: description, tag_words: tag_words, deadline: deadline)
    click_button I18n.t('helpers.submit.update')
  end

  def fill_in_task_form(title: nil, description: nil, tag_words: nil, deadline: nil, with_sign_up: false)
    fill_in 'task_parameters[tag_words]', with: tag_words if tag_words
    fill_in 'task_parameters[title]', with: title if title
    fill_in 'task_parameters[description]', with: description if description
    fill_in_deadline(deadline)
    find('#task_parameters_with_sign_up_label', visible: false).click if with_sign_up
  end

  def disable_deadline_from_ui(old_task)
    visit edit_task_path(old_task.id)
    find('#task_parameters_disable_deadline', visible: false).trigger('click')
    click_button I18n.t('helpers.submit.update')
  end

  private

    def fill_in_deadline(deadline)
      return unless deadline
      if deadline.is_a?(Time)
        fill_in_deadline_fields(
          date: deadline.strftime('%Y/%m/%d'),
          hour: deadline.strftime('%H'),
          minutes: deadline.strftime('%M'),
        )
      else
        fill_in_deadline_fields(
          date: deadline[:date],
          hour: deadline[:hour],
          minutes: deadline[:minutes],
        )
      end
    end

    def fill_in_deadline_fields(date: nil, hour: nil, minutes: nil)
      fill_in 'task_parameters[deadline_date]', with: date if date
      select hour, from: 'task_parameters[deadline_hour]' if hour
      select minutes, from: 'task_parameters[deadline_minutes]' if minutes
    end
end
