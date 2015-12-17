class TagCollection
  attr_reader :tags
  alias_method :to_a, :tags

  def self.create_from_taggings(taggings)
    new.tap do |me|
      me.add(taggings.sort_by(&:id).map(&:tag))
    end
  end

  def add(tags)
    @tags = tags
  end

  def remove_all!
    @tags = []
  end

  def associate_with_task(task)
    clear_association(task)
    build_association(task)
  end

  private

    def clear_association(task)
      task.taggings.destroy_all
    end

    def build_association(task)
      @tags.each do |tag|
        task.taggings.build(tag: tag)
      end
    end
end
