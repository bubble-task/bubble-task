module Criteria
  AssociationPlan = Struct.new(:relation, :join_type) do

    def associate(base_relation)
      Association.new(base_relation, join_type, relation)
    end
  end
end
