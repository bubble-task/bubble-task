class TagPresenter

  def self.create(tags)
    return [PersonalTag.new] if tags.empty?
    tags.map { |tag| SharedTag.new(tag) }
  end

  class PersonalTag

    def present(_)
      %(<div class="tag-personal">#{I18n.t('tasks.show.tag_personal')}</div>).html_safe
    end
  end

  class SharedTag

    def initialize(tag)
      @tag = tag
    end

    def present(view)
      %(<div class="tag">#{view.link_to @tag, view.tasks_url(tag: @tag)}</div>).html_safe
    end
  end
end
