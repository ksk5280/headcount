require 'csv'
require 'set'
require 'enrollment'
require 'data_loader'

class EnrollmentRepository
  attr_reader :districts


  def load_data(data)
    @districts = DataLoader.new.load_csv(data)
  end

  def find_by_name(name)
    if districts.include?(name=name.upcase)
      Enrollment.new({:name => name})
    else
      nil
    end
  end
end
