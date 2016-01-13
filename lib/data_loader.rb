require 'csv'
require 'set'
require 'pry'

class DataLoader

  def load_csv(data)
    file_name = data.fetch(:enrollment).fetch(:kindergarten)
    data = CSV.open "#{file_name}",
      headers: true,
      header_converters: :symbol
    # if type == 'districts'
    #   districts = Set.new
    #   data.each do |row|
    #     districts << row[:location].upcase
    #   end
    #   districts
      # districts is a set of unique district names
    # elsif type == 'enrollments'
      enrollments = {}
      data.each do |row|
        district = row[:location].upcase
        year = row[:timeframe].to_i
        percentage = row[:data].to_f
        if !enrollments.has_key?(district)
          enrollments[district] = {}
        end
        enrollments[district][year] = percentage
      end
      enrollments
      # enrollments:
      # {
      #   district_A => { year1 => %, year2 => %, ... },
      #   district_B => { year1 => %, year2 => %, ... },
      #   ...
      # }
  #   end
  end
end

if __FILE__ == $0

end
