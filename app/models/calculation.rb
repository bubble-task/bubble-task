class Calculation
  include ActiveModel::Model

  attr_accessor :left, :right, :operator

  def self.operators
    [:+, :-, :*, :/]
  end

  validates :left, numericality: true
  validates :right, numericality: true
  validates_inclusion_of :operator, in: operators, message: 'Operator is not operation symbol'

  def compute!
    if valid?
      @answer = left.to_i.send(operator, right.to_i)
    end
  end

  def describe
    "#{left} #{operator} #{right} = #{@answer}"
  end
end
