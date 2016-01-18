class District
  attr_reader :name
  attr_accessor :enrollment,
                :statewide_test

  def initialize(data)
    @name = data[:name].upcase
    @enrollment = data[:enrollment]
    @statewide_test = data[:statewide_testing]
  end

end
