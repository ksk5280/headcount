require 'csv'
require 'set'
require 'pry'

class DataLoader

  def load_csv(data)
    file_name = data.fetch(:enrollment).fetch(:kindergarten)
    # raise argument if file does not exist?
    data = CSV.open "#{file_name}",
      headers: true,
      header_converters: :symbol
      enrollments = {}
      data.each do |row|
        district = row[:location].upcase
        year = row[:timeframe].to_i
        percentage = row[:data].to_f
        # exclude lines if N/A or #Div/0?
        if !enrollments.has_key?(district)
          enrollments[district] = {}
        end
        enrollments[district][year] = percentage
      end
      enrollments
      # enrollments:
      # {
      #   "district_A" => { year1 => %, year2 => %, ... },
      #   "district_B" => { year1 => %, year2 => %, ... },
      #   ...
      # }
  #   end
  end
end

if __FILE__ == $0
  dl = DataLoader.new
  puts dl.load_csv({
    :enrollment => {
      :kindergarten => "test/fixtures/kindergarten_fixture.csv"
    }
  })
end
