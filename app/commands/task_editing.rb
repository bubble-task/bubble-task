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
    update_deadline(@form.deadline, @form.disable_deadline?)
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

    def update_deadline(deadline, is_disable_deadline)
      return @origin.remove_deadline if is_disable_deadline
      return unless deadline
      @origin.reset_deadline(deadline)
    end

    def save
      @origin.save
    end
end
