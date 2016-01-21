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
