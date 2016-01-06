module Criteria
  module Conditions
    Tag = Struct.new(:tag) do
      extend Creatable

      def self.create(value)
        super
      end

      def satisfy(relation)
        relation.where(taggings: { tag: tag })
      end
    end
  end
end
