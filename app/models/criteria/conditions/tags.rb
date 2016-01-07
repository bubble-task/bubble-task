module Criteria
  module Conditions
    Tags = Struct.new(:tags) do
      extend Creatable

      def self.create(tag_words)
        tags = TaskParameters.tags_from(tag_words)
        return super(nil) if tags.empty?
        super(tags)
      end

      def prepare(relation)
        relation.use_joins
      end

      def satisfy(relation)
        relation.restrict_by_tags(tags)
      end
    end
  end
end
