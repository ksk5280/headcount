require 'csv'
require 'pry'
require 'pry-byebug'

class DataLoader
  attr_reader :enrollments

  def load_csv(data)
    #create a block to load each key of enrollment
    @enrollments = {}
    data.fetch(:enrollment).each_key do |key|
      file_name = data.fetch(:enrollment).fetch(key)
      if File.exist?("#{file_name}") == false
        raise ArgumentError,  "This is not a valid file. Please provide a valid CSV file."
      else
        file = CSV.open "#{file_name}",
        headers: true,
        header_converters: :symbol
        enrollments = parse_data(file)
      end
    end
    enrollments
    # file_name = data.fetch(:enrollment).fetch(:kindergarten)
    # hs_file_name = data.fetch(:enrollment).fetch(:high_school_graduation)
  end

  def parse_data(data)
    data.each do |row|
      district = row[:location].upcase
      year = row[:timeframe].to_i
      percentage = clean_percentage(row[:data])
      create_enrollments_hash(district, year, percentage)
    end
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
  # dl = DataLoader.new
  # puts dl.load_csv({
  #   :enrollment => {
  #     :kindergarten => "test/fixtures/small_kg_fixture.csv",
  #     :high_school_graduation => "test/fixtures/small_hs_fixture.csv"
  #   }
  # })
  dl = DataLoader.new.load_csv({
    :enrollment => {
      :kindergarten => "test/fixtures/kindergarten_fixture.csv"
    }
  })
  puts "enrollments at bottom"
  puts dl
  puts dl.count
end
