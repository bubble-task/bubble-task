class TaskEditing
  attr_reader :form

  def initialize(origin, form)
    @origin = origin
    @form = form
  end

  def run
    return false unless @form.valid?
    update_title(@form.title)
    update_tags(@form.tags)
    update_description(@form.description)
    if @form.disable_deadline?
      @origin.remove_deadline
    else
      @origin.reset_deadline(@form.deadline)
    end

    save
  end

  private

    def update_title(title)
      @origin.retitle(title)
    end

    def update_tags(tags)
      @origin.tagging_by(tags)
    end

    def update_description(description)
      return @origin.remove_description if description.blank?
      @origin.rewrite_description(description)
    end

    def save
      @origin.save
    end
end
