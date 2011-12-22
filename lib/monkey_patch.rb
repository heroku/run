class Object

  def blank?
    respond_to?(:empty?) ? empty? : !self
  end

  def present?
    !blank?
  end

end

class NilClass

  def blank?
    true
  end

  def delay
    Time.now.to_i
  end

  def ord
    0
  end

end

class Array

  alias_method :blank?, :empty?

end

class Hash

  alias_method :blank?, :empty?

end

class String

  def blank?
    self !~ /\S/
  end

  def delay
    Time.now.to_i - self.to_i
  end

end

class Numeric

  def blank?
    false
  end

  def seconds
    self
  end
  alias :second :seconds

  def minutes
    self * 60
  end
  alias :minute :minutes

  def hours
    self * 60 * 60
  end
  alias :hour :hours

  def days
    self * 60 * 60 * 24
  end
  alias :day :days

  def delay
    Time.now.to_i - self
  end

  def jitter
    self + self * rand * 0.15
  end

end

class Time

  def delay
    Time.now.to_i - self.to_i
  end

end
