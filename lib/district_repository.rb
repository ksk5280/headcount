require 'csv'
require 'pry'
require 'set'
class DistrictRepository
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
      District.new({:name => name})
    else
      nil
    end
  end

  def find_all_matching(name_fragment)
    matching_districts = []
    districts.each do |district|
      if district.include?(name_fragment.upcase)
        matching_districts << district
      end
    end
    matching_districts
  end

end
#
# dr = DistrictRepository.new
# dr.load_data({:enrollment => {
#                           :kindergarten => "test/fixtures/kindergarten_fixture.csv"}
#                         })
