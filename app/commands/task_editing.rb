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
    update_description(description)
    @origin.save
  end

  private

    def update_description(description)
      return @origin.remove_description if description.blank?
      return @origin.rewrite_description(description)
    end
end
