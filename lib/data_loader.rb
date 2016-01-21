require 'csv'
require 'pry'

class DataLoader
  attr_reader :enrollments,
              :statewide_tests,
              :economic_profiles,
              :type,
              :results

  def initialize
    @results = {}
    @enrollments = {}
    @statewide_tests = {}
    @economic_profiles = {}
  end

  def load_enrollments_csv(data)
    load(:enrollment, data)
    enrollments
  end

  def load_statewide_tests_csv(data)
    load(:statewide_testing, data)
    statewide_tests
  end

  def load_economic_csv(data)
    load(:economic_profile, data)
    economic_profiles
  end

  def load(key, data)
    data.fetch(key).each do |k, file_name|
      @type = k
      load_csv(file_name, key)
    end
  end

  def load_csv(file_name, type)
    if File.exist?("#{file_name}") == false
      raise InvalidFileError,  "This is not a valid file. Please provide a valid CSV file."
    else
      file = CSV.open "#{file_name}",
      headers: true,
      header_converters: :symbol
      parse_data(file, type)
    end
  end

  def parse_data(data, type)
    data.each do |row|
      district = row[:location].upcase
      year = format_year(row[:timeframe])
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

  def format_year(unformatted_year)
    if unformatted_year.length < 5
      unformatted_year.to_i
    else
      unformatted_year.split('-').map(&:to_i)
    end
  end

  def clean_data_format(data_format)
    data_format = data_format.downcase
    if data_format == 'percent'
      data_format = :percentage
    elsif data_format == 'number'
      data_format = :total
    elsif data_format == 'currency'
      data_format = :currency
    end
    data_format
  end

  # def create_enrollments_hash(district, year, percentage)
  #   type = :enrollment
  #   build_or_check_hash(enrollments, district, type, year).dup
  #   unless percentage == nil
  #     enrollments[district][type][year] = percentage
  #   end
  # end
  #
  # def build_or_check_hash(a_hash, *some_keys)
  #   temp_hash = a_hash
  #   some_keys.each do |key|
  #     temp_hash[key] = {} if temp_hash.empty?
  #     temp_hash = temp_hash[key]
  #   end
  # end

  def start_hash(district)
    unless enrollments.has_key?(district)
      enrollments[district] = {}
    end
  end

  def create_enrollments_hash(district, year, percentage)
    unless enrollments.has_key?(district)
      enrollments[district] = {}
    end
    start_hash(district)
    unless enrollments[district].has_key?(type)
      enrollments[district][type] = {}
    end
    unless percentage == nil
      enrollments[district][type][year] = percentage
    end
  end

  def create_test_hash(district, subject_or_race, year, percentage)
    if !statewide_tests.has_key?(district)
      statewide_tests[district] = {}
    end
    if !statewide_tests[district].has_key?(type)
      statewide_tests[district][type] = {}
    end
    if !statewide_tests[district][type].has_key?(year)
      statewide_tests[district][type][year] = {}
    end
    statewide_tests[district][type][year][subject_or_race] = percentage unless percentage == nil
  end

  def create_economic_hash(district, year, number, data_format)
    if !economic_profiles.has_key?(district)
      economic_profiles[district] = {}
    end
    if !economic_profiles[district].has_key?(type)
      economic_profiles[district][type] = {}
    end
    if !economic_profiles[district][type].has_key?(year)
      economic_profiles[district][type][year] = {}
    end
    if type == :free_or_reduced_price_lunch
      economic_profiles[district][type][year][data_format] = number unless number == nil
    else
      economic_profiles[district][type][year] = number unless number == nil
    end
  end

  def clean_percentage(number, data_format, poverty_level)
    if number =~ /^\d+\.?\d*$/
      return number.to_i if data_format == :currency
      if !poverty_level.nil? && data_format == :percentage
        return number.to_f.round(3) if poverty_level == 'Eligible for Free or Reduced Lunch'
      elsif !poverty_level.nil? && data_format == :total
        return number.to_i if poverty_level == 'Eligible for Free or Reduced Lunch'
      elsif data_format.downcase == :percentage
        number.to_f.round(3)
      end
    end
  end
end
