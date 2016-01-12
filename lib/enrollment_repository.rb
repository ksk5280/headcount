require 'csv'
require 'pry'
require 'set'
require 'enrollment'

class EnrollmentRepository
  attr_reader :districts,
              :unique_data


  def load_data(data)
    data = CSV.open "#{data.fetch(:enrollment).fetch(:kindergarten)}", headers: true, header_converters: :symbol
    @districts = Set.new

    data.each do |row|
    districts << row[:location].upcase
    end
    # districts is a set of unique district names
  end

  def find_by_name(name)
    if districts.include?(name=name.upcase)
      Enrollment.new({:name => name})
    else
      nil
    end
  end
end
