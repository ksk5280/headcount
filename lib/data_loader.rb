require 'csv'
require 'pry'

class DataLoader
  attr_reader :enrollments,
              :school_age,
              :statewide_tests,
              :testing_type,
              :economic_profiles,
              :economic_type

  def load_enrollments_csv(data)
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

  def load_economic_csv(data)
    @economic_profiles = {}
    data.fetch(:economic_profile).each_key do |key|
      @economic_type = key
      file_name = data.fetch(:economic_profile).fetch(key)
      load_csv(file_name, :economic_profile)
    end
    economic_profiles
  end

  def load_csv(file_name, type)
    if File.exist?("#{file_name}") == false
      raise InvalidFileError,  "This is not a valid file. Please provide a valid CSV file."
    else
      file = CSV.open "#{file_name}",
      headers: true,
      header_converters: :symbol
      if type == :enrollment
        enrollments = parse_data(file, type)
      elsif type == :statewide_testing
        statewide_tests = parse_data(file, type)
      elsif type == :economic_profile
        economic_profiles = parse_data(file, type)
      end
    end
  end

  def parse_data(data, type)
    data.each do |row|
      district = row[:location].upcase
      year = row[:timeframe]
      if year.length < 5
        year = year.to_i
      else
        year = year.split('-').map(&:to_i)
      end
      # data_format = row[:dataformat].downcase
      data_format = clean_data_format(row[:dataformat])
      percentage = clean_percentage(row[:data], data_format, row[:poverty_level])
      if type == :enrollment
        create_enrollments_hash(district, year, percentage)
      elsif type == :statewide_testing
        if !row[:score].nil?
          subject_or_race = row[:score].downcase.to_sym
        elsif !row[:race_ethnicity].nil?
          subject_or_race = row[:race_ethnicity].downcase.to_sym
        end
        create_test_hash(district, subject_or_race, year, percentage)
      elsif type == :economic_profile
        create_economic_hash(district, year, percentage, data_format)
      end
    end
  end

  def clean_data_format(data_format)
    data_format = data_format.downcase
    if data_format == 'percent'
      data_format = :percentage
    elsif data_format == 'number'
      data_format = :total
    end
    data_format
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

  def create_economic_hash(district, year, number, data_format)
    if !economic_profiles.has_key?(district)
      economic_profiles[district] = {}
    end
    if !economic_profiles[district].has_key?(economic_type)
      economic_profiles[district][economic_type] = {}
    end
    if !economic_profiles[district][economic_type].has_key?(year)
      economic_profiles[district][economic_type][year] = {}
    end
    # if economic_type == :free_or_reduced_price_lunch && !economic_profiles[district][economic_type].has_key?(data_format)
    #   economic_profiles[district][economic_type][year][data_format] = {}
    # end
    if economic_type == :free_or_reduced_price_lunch
      economic_profiles[district][economic_type][year][data_format] = number unless number == nil
    else
      economic_profiles[district][economic_type][year] = number unless number == nil
    end
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

  def clean_percentage(number, data_format, poverty_level)
    # regex => if it's not a number then nil
    if number == 'N/A' || number == '#DIV/0!' || number == 'LNE'
      nil
    elsif data_format.downcase == 'currency'
      number = number.to_i
    elsif !poverty_level.nil? && data_format == :percentage
      return number.to_f.round(3) if poverty_level == 'Eligible for Free or Reduced Lunch'
    elsif !poverty_level.nil? && data_format == :total
      return number.to_i if poverty_level == 'Eligible for Free or Reduced Lunch'
    elsif data_format.downcase == :percentage
      number.to_f.round(3)
    else
      nil
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
