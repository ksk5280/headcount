$LOAD_PATH.unshift(File.expand_path('.',__dir__))
require 'csv'
require 'set'
require_relative 'district'
require_relative 'data_loader'
#require_relative 'enrollment_repository'
#require_relative 'enrollment'

class DistrictRepository
  attr_reader :districts

  #create an enrollment repository when creating a
  #district repository

  # def enrollment
  #
  #   er = EnrollmentRepository.new
  #   er.find_by_name
  #   creates e = Enrollment.new
  # end

  def load_data(data)
    @districts = DataLoader.new.load_csv(data)
  end

  def find_by_name(name)
    if districts.include?(name=name.upcase)
      District.new({:name => name})
      # Enrollment.new(data)
    else
      nil
    end
  end

  def find_all_matching(name_fragment)
    # could try regex instead of include. which is faster?
    matching_districts = []
    districts.each do |district|
      if district.include?(name_fragment.upcase)
        matching_districts << district
      end
    end
    matching_districts
  end
end

if __FILE__ == $0
  begin
    dr = DistrictRepository.new
    start = Time.now
    dr.load_data({:enrollment => {
                    :kindergarten => "data/Kindergartners in full-day program.csv"}
                  })
    p dr.districts
    p "number of districs = #{dr.districts.count}"
  end
    finish = Time.now
    p "time (s): #{finish - start}"
end
