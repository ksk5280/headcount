require_relative 'district'
require_relative 'data_loader'
require_relative 'enrollment_repository'
require_relative 'enrollment'
require_relative 'statewide_test_repository'

class DistrictRepository
  attr_reader :districts,
              :enrollment_repository,
              :statewide_testing_repository,
              :economic_profile_repository,
              :data

  def initialize
    @enrollment_repository = EnrollmentRepository.new
    @statewide_testing_repository = StatewideTestRepository.new
    @economic_profile_repository = EconomicProfileRepository.new
  end

  def load_data(data)
    @data = data
    if data.has_key?(:enrollment)
      enrollment_repository.load_data(data)
      @districts = enrollment_repository.enrollments
    end
    if data.has_key?(:statewide_testing)
      statewide_testing_repository.load_data(data)
      @districts = statewide_testing_repository.statewide_tests
    end
    if data.has_key?(:economic_profile)
      economic_profile_repository.load_data(data)
      @districts = economic_profile_repository.economic_profiles
    end
  end

  def find_by_name(name)
    name = name.upcase
    if districts.has_key?(name)
      if data.has_key?(:enrollment)
        district = District.new({
          :name => name,
          :enrollment => enrollment_repository.find_by_name(name)
        })
      end
      if data.has_key?(:statewide_testing)
        district = District.new({
          :name => name,
          :statewide_testing => statewide_testing_repository.find_by_name(name)
        })
      end
      if data.has_key?(:economic_profile)
        district = District.new({
          :name => name,
          :economic_profile => economic_profile_repository.find_by_name(name)
        })
      end
    end
    district
  end

  def find_all_matching(name_fragment)
    matching_districts = districts.select do |district, _v|
      district.include?(name_fragment.upcase)
    end
    matching_districts.keys
  end
end
