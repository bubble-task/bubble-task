module Criteria
  module Conditions
    Tags = Struct.new(:tag_words) do
      extend Creatable

      def prepare(relation)
        relation.use_joins
      end

      def satisfy(relation)
        tags = TaskParameters.tags_from(tag_words)
        relation
          .where(taggings: { tag: tags })
          .group('tasks.id')
          .having("COUNT(tasks.id) = #{tags.size}")
      end
    end
  end
end
