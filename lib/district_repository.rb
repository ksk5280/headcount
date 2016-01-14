require 'csv'
require 'set'
require_relative 'district'
require_relative 'data_loader'
require_relative 'enrollment_repository'
require_relative 'enrollment'

class DistrictRepository
  attr_reader :districts, :enrollment_repository

  def load_data(data)
    if data.has_key?(:enrollment)
      @enrollment_repository = EnrollmentRepository.new
      enrollment_repository.load_data(data)
      @districts = enrollment_repository.enrollments
    else
      raise ArgumentError, 'data needs :enrollment key'
    end
    # if data.has_key?(:statewide_testing)
    #   @statewide_testing_repository = StatewideTestRepository.new
    #   statewide_testing_repository.load_data(data)
    # end
  end

  def find_by_name(name)
    name = name.upcase
    if districts.has_key?(name)
      District.new({
        :name => name,
        :enrollment => enrollment_repository.find_by_name(name)
      })
    end
  end

  def find_all_matching(name_fragment)
    matching_districts = districts.select do |district, _v|
      district.include?(name_fragment.upcase)
    end
    matching_districts.keys
  end
end

if __FILE__ == $0
  dr = DistrictRepository.new
  # start = Time.now
  # district = dr.find_by_name("COLORADO")
  # p district.enrollment
  file = "test/fixtures/kindergarten_edge_cases.csv"
  # file = "data/Kindergartners in full-day program.csv"
  puts dr.load_data({
    :enrollment => {
      :kindergarten => file
    }
  })
  # p "number of districs = #{dr.districts.count}"
  # finish = Time.now
  # p "time (s): #{finish - start}"
  # p dr.find_by_name("Colorado")
  #   .enrollment.kindergarten_participation_in_year(2010)
end
