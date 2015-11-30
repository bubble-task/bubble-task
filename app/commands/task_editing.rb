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
    update_title(title)
    update_tags(tags)
    update_description(description)
    save
  end

  private

    def update_title(title)
      @origin.retitle(title)
    end

    def update_tags(tags)
      @origin.remove_tags
      @origin.tagging(tags)
    end

    def update_description(description)
      return @origin.remove_description if description.blank?
      @origin.rewrite_description(description)
    end

    def save
      @origin.save
    end
end
