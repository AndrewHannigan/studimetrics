class MathConversions
  def self.number_to_float(fraction)
    numerator, denominator = fraction.to_s.split('/').map(&:to_f)
    denominator ||= 1
    numerator/denominator
  end
end
