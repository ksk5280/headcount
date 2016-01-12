require 'csv'
require 'pry'
require 'set'
class DistrictRepository
  attr_reader :districts

  def load_data(data)
    data = CSV.open "#{data.fetch(:enrollment).fetch(:kindergarten)}", headers: true, header_converters: :symbol
    unique_data = Set.new

    data.each do |row|
    unique_data << row[:location]
    end

    @districts = unique_data.map do |location|
      District.new({:name => location})
    end
  end

end
#
# dr = DistrictRepository.new
# dr.load_data({:enrollment => {
#                           :kindergarten => "test/fixtures/kindergarten_fixture.csv"}
#                         })
