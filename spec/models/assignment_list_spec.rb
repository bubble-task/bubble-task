require 'rails_helper'

class AssignmentSpy
  attr_reader :persisted, :saved
  alias_method :persisted?, :persisted
  alias_method :saved?, :saved

  def initialize(persisted)
    @persisted = persisted
    @saved = false
  end

  def save
    @saved = true
  end
end

describe AssignmentList do
  describe '#add' do
    it do
      new_list = described_class.new.add(:assignment)
      expect(new_list).to eq([:assignment])
    end
  end

  describe '#save' do
    it do
      persisted_assignment = AssignmentSpy.new(true)
      new_assignment = AssignmentSpy.new(false)

      list = described_class.new([persisted_assignment, new_assignment])
      list.save

      expect(persisted_assignment).to_not be_saved
      expect(new_assignment).to be_saved
    end
  end
end
