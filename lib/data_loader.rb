require 'csv'
require 'pry'

class DataLoader
  attr_reader :enrollments,
              :school_age,
              :statewide_tests,
              :testing_type

  def load_enrollments_csv(data)
    #create a block to load each key of enrollment
    @enrollments = {}
    data.fetch(:enrollment).each_key do |key|
      @school_age = key
      file_name = data.fetch(:enrollment).fetch(key)
      load_csv(file_name, :enrollment)
    end
    enrollments
  end


  def load_statewide_tests_csv(data)
    @statewide_tests = {}
    data.fetch(:statewide_testing).each_key do |key|
      @testing_type = key
      file_name = data.fetch(:statewide_testing).fetch(key)
      load_csv(file_name, :statewide_testing)
    end
    statewide_tests
  end

  def load_csv(file_name, type)
    if File.exist?("#{file_name}") == false
      raise ArgumentError,  "This is not a valid file. Please provide a valid CSV file."
    else
      file = CSV.open "#{file_name}",
      headers: true,
      header_converters: :symbol
      if type == :enrollment
        enrollments = parse_data(file, type)
      else
        statewide_tests = parse_data(file, type)
      end
    end
  end

  def parse_data(data, type)
    data.each do |row|
      district = row[:location].upcase
      year = row[:timeframe].to_i
      percentage = clean_percentage(row[:data])
      if type == :enrollment
        create_enrollments_hash(district, year, percentage)
      elsif type == :statewide_testing
        if !row[:score].nil?
          subject_or_race = row[:score].downcase.to_sym
        elsif !row[:race_ethnicity].nil?
          subject_or_race = row[:race_ethnicity].downcase.to_sym
        end
        create_test_hash(district, subject_or_race, year, percentage)
      end
    end
  end

  def create_enrollments_hash(district, year, percentage)
    if !enrollments.has_key?(district)
      enrollments[district] = {}
    end
    if !enrollments[district].has_key?(school_age)
      enrollments[district][school_age] = {}
    end
    # enrollments[district] = { school_age => {} }

    # {:kindergarten=>{}}
    enrollments[district][school_age][year] = percentage unless percentage == nil

  end

  def create_test_hash(district, subject_or_race, year, percentage)
    if !statewide_tests.has_key?(district)
      statewide_tests[district] = {}
    end
    if !statewide_tests[district].has_key?(testing_type)
      statewide_tests[district][testing_type] = {}
    end
    if !statewide_tests[district][testing_type].has_key?(year)
      statewide_tests[district][testing_type][year] = {}
    end

    statewide_tests[district][testing_type][year][subject_or_race] = percentage unless percentage == nil

  end

  # enrollments:
  # {
  #   "district_A" => { kindergarten => { year1 => %, year2 => %, ... },
  #                     high_school  => { year1 => %, year2 => %, ... }
  #                    }
  #   "district_B" => { kindergarten => { year1 => %, year2 => %, ... },
  #                     high_school  => { year1 => %, year2 => %, ... }
  #                    }
  #   ...
  # }

  def clean_percentage(percentage)
    # regex => if it's not a number then nil
    if percentage == 'N/A' || percentage == '#DIV/0!'
      nil
    else
      percentage.to_f.round(3)
    end
  end

end

if __FILE__ == $0
  # dl = DataLoader.new
  # puts dl.load_enrollments_csv({
  #   :enrollment => {
  #     :kindergarten => "test/fixtures/small_kg_fixture.csv",
  #     :high_school_graduation => "test/fixtures/small_hs_fixture.csv"
  #   }
  # })
  # dl = DataLoader.new.load_enrollments_csv({
  #   :enrollment => {
  #     :kindergarten => "test/fixtures/kindergarten_fixture.csv"
  #   }
  # })
  # puts "enrollments at bottom"
  # puts dl
  # puts dl.count

end
