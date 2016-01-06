module Criteria
  module Conditions
    Tag = Struct.new(:tag) do
      extend Creatable

      def self.create(value)
        super
      end

      def satisfy(relation)
        relation.restrict_by_tag(tag)
      end
    end
  end
end
