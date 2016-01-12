require 'csv'
require 'set'

class DataLoader

  def load_csv(data)
    data = CSV.open "#{data.fetch(:enrollment).fetch(:kindergarten)}",
                    headers: true, header_converters: :symbol
    districts = Set.new
    data.each do |row|
    districts << row[:location].upcase
    end
    districts
    # districts is a set of unique district names
  end
end
