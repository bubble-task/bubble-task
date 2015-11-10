class Calculation
  include ActiveModel::Model

  OPERATORS = %w(+ - * /).freeze

  attr_accessor :left, :right, :operator

  validates :left, numericality: true
  validates :right, numericality: true
  validates :operator, inclusion: { in: OPERATORS, message: 'Operator is not operation symbol' }

  def self.operators
    OPERATORS
  end

  def compute!
    return unless valid?
    @answer = left.to_i.send(operator, right.to_i)
  end

  def describe
    "#{left} #{operator} #{right} = #{@answer}"
  end
end
