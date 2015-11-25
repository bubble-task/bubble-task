module TaskCreationHelper

  def create_task_from_ui(title, description = '', tag_words = '')
    visit new_task_path
    fill_in I18n.t('activemodel.attributes.task_creation.title'), with: title
    fill_in I18n.t('activemodel.attributes.task_creation.description'), with: description
    fill_in I18n.t('activemodel.attributes.task_creation.tag_words'), with: tag_words
    click_button '作成する'
  end

  def create_task(*args)
    TaskFactory
      .create(*args)
      .tap(&:save)
  end
end
