require 'csv'
require 'set'
require 'pry'

class DataLoader

  def load_csv(data)
    # binding.pry
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
