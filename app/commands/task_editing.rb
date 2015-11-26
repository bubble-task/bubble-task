class TaskEditing
  include ActiveModel::Model

  class << self

    def from_task(task)
      new(
        task_id: task.id,
        title: task.title,
        description: task.description,
        tag_words: build_tag_words(task.tags)
      )
    end

    def build_tag_words(tags)
      tags.join(' ')
    end
  end

  attr_accessor :task_id, :title, :description, :tag_words
end
