class TaskEditing < SimpleDelegator
  class << self

    def from_origin(origin)
      new(
        origin,
        TaskParameters.new(
          title: origin.title,
          description: origin.description,
          tag_words: build_tag_words(origin.tags)
        )
      )
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
    @origin.rewrite_description(description)
    @origin.save
  end
end
