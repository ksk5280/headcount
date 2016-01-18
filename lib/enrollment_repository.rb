require 'csv'
require_relative 'enrollment'
require_relative 'data_loader'

class EnrollmentRepository
  attr_reader :enrollments

  def load_data(data)
    @enrollments = DataLoader.new.load_enrollments_csv(data)
   end

  def find_by_name(name)
    name = name.upcase
    if enrollments.has_key?(name)
      Enrollment.new({
        :name => name,
        :kindergarten_participation => enrollments.fetch(name)[:kindergarten],
        :high_school_graduation => enrollments.fetch(name)[:high_school_graduation]
      })
    end
  end
end

if __FILE__ == $0
  er = EnrollmentRepository.new
  er.load_data({
    :enrollment => {
      :kindergarten => "test/fixtures/small_kg_fixture.csv",
      :high_school_graduation => "test/fixtures/small_hs_fixture.csv"
    }
  })
  puts er.enrollments
  puts er.find_by_name("ADAMS COUNTY 14")
end
