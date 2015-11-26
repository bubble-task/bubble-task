class TaskEditing
  include ActiveModel::Model

  attr_accessor :origin, :title, :description, :tag_words

  def initialize(params)
    if parameters?(params)
      super(params)
    else
      set_attributes_from_origin(params[:origin])
    end
  end

  def task_id
    origin.id
  end

  def run
    origin.retitle(title)
    origin.rewrite_description(description)
    origin.save
  end

  private

    def set_attributes_from_origin(origin)
      self.origin = origin
      self.title = origin.title
      self.description = origin.description
      self.tag_words = build_tag_words(origin.tags)
    end

    def build_tag_words(tags)
      tags.join(' ')
    end

    def parameters?(params)
      params
        .values_at(:title, :description, :tag_words)
        .compact
        .any?
    end
end
