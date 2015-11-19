module TaskCreationHelper

  def create_task(title, description = '', tag_words = '')
    fill_in I18n.t('activemodel.attributes.task_creation.title'), with: title
    fill_in I18n.t('activemodel.attributes.task_creation.description'), with: description
    fill_in I18n.t('activemodel.attributes.task_creation.tag_words'), with: tag_words
    click_button '作成する'
  end
end
