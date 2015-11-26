class TaskEditing
  include ActiveModel::Model

  attr_accessor :origin, :title, :description, :tag_words

  validates :title,
            presence: true

  class << self

    def from_origin(origin)
      new(
        origin: origin,
        title: origin.title,
        description: origin.description,
        tag_words: build_tag_words(origin.tags)
      )
    end

    def build_tag_words(tags)
      tags.join(' ')
    end
  end

  def task_id
    origin.id
  end

  def run
    return false unless valid?
    origin.retitle(title)
    origin.rewrite_description(description)
    origin.save
  end
end
