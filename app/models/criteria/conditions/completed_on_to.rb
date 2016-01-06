module Criteria
  module Conditions
    CompletedOnTo = Struct.new(:datetime) do
      extend Creatable

      def prepare(relation)
        relation
      end

      def satisfy(relation)
        relation.restrict_by_complated_before(datetime)
      end
    end
  end
end
