require 'csv'
require 'set'
require 'pry'

class DataLoader
  attr_reader :enrollments

  def load_csv(data)
    file_name = data.fetch(:enrollment).fetch(:kindergarten)
    if File.exist?("#{file_name}") == false
      raise ArgumentError,  "This is not a valid file. Please provide a valid CSV file."
    else
      data = CSV.open "#{file_name}",
        headers: true,
        header_converters: :symbol
      parse_data(data)
    end
  end

  def parse_data(data)
    @enrollments = {}
    data.each do |row|
      district = row[:location].upcase
      year = row[:timeframe].to_i
      percentage = clean_percentage(row[:data])
      create_enrollments_hash(district, year, percentage)
    end
    enrollments
    # enrollments:
    # {
    #   "district_A" => { year1 => %, year2 => %, ... },
    #   "district_B" => { year1 => %, year2 => %, ... },
    #   ...
    # }
  end

  def create_enrollments_hash(district, year, percentage)
    if !enrollments.has_key?(district)
      enrollments[district] = {}
    end
    enrollments[district][year] = percentage unless percentage == nil
  end

  def clean_percentage(percentage)
    # regex => if it's not a number then nil
    if percentage == 'N/A' || percentage == '#DIV/0!'
      nil
    else
      percentage.to_f
    end
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
