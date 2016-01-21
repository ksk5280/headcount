class District
  attr_reader :name
  attr_accessor :enrollment,
                :statewide_test,
                :economic_profile

  def initialize(data)
    @name = data[:name].upcase
    @enrollment = data[:enrollment]
    @statewide_test = data[:statewide_testing]
    @economic_profile = data[:economic_profile]
  end
end
