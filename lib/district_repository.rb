$LOAD_PATH.unshift(File.expand_path('.',__dir__))
require 'csv'
require 'pry'
require 'set'
require_relative 'district'

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
