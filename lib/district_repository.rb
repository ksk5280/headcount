$LOAD_PATH.unshift(File.expand_path('.',__dir__))
require 'csv'
require 'set'
require_relative 'district'
require_relative 'data_loader'
require_relative 'enrollment_repository'
require_relative 'enrollment'

class DistrictRepository
  attr_reader :districts, :enrollment_repository

  #create an enrollment repository when creating a
  #district repository

  def load_data(data)
    if data.has_key?(:enrollment)
      @enrollment_repository = EnrollmentRepository.new
      enrollment_repository.load_data(data)
      @districts = enrollment_repository.enrollments
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
      # Enrollment.new(data)
    else
      nil
    end
  end

  def find_all_matching(name_fragment)
    # could try regex instead of include. which is faster?
    matching_districts = []
    districts.each_key do |district|
      if district.include?(name_fragment.upcase)
        matching_districts << district
      end
    end
    matching_districts
  end
end

if __FILE__ == $0
  dr = DistrictRepository.new
  start = Time.now
  dr.load_data({
    :enrollment => {
      :kindergarten => "data/Kindergartners in full-day program.csv"
    }
  })
  p "number of districs = #{dr.districts.count}"
  finish = Time.now
  p "time (s): #{finish - start}"
  p dr.find_by_name("Colorado").enrollment.kindergarten_participation_in_year(2010)
end
