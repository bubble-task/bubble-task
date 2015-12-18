module Criteria
  module Conditions
    Author = Struct.new(:id) do
      extend Creatable

      def satisfy(relation)
        relation.restrict_by_author(id)
      end
    end
  end
end
