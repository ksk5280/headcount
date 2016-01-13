class District
  attr_reader :name
  attr_accessor :enrollment

  def initialize(data)
    @name = data[:name].upcase
    @enrollment = data[:enrollment]
  end

end
