module Criteria
  module Conditions
    Tags = Struct.new(:tag_words) do
      extend Creatable

      def prepare(relation)
        relation.use_joins
      end

      def satisfy(relation)
        tags = TaskParameters.tags_from(tag_words)
        relation.restrict_by_tags(tags)
      end
    end
  end
end
