class TaskEditing < SimpleDelegator
  class << self

    def from_origin(origin)
      parameters = TaskParameters.new(
        title: origin.title,
        description: origin.description,
        tag_words: build_tag_words(origin.tags),
      )
      new(origin, parameters)
    end

    def build_tag_words(tags)
      tags.join(' ')
    end
  end

  def initialize(origin, parameters)
    super(parameters)
    @origin = origin
  end

  def task_id
    @origin.id
  end

  def run
    return false unless valid?
    @origin.retitle(title)
    if description.present?
      @origin.rewrite_description(description)
    else
      @origin.remove_description
    end
    @origin.save
  end
end
