require 'data_loader'
require 'test_helper'

class DataLoaderTest < Minitest::Test
  def test_data_loader_can_take_in_a_file
    enrollments = DataLoader.new.load_enrollments_csv({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    assert_equal 2, enrollments.count
  end

  def test_load_enrollments_csv_file_and_create_enrollments_keys
    enrollments = DataLoader.new.load_enrollments_csv({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    expected = ["COLORADO", "ACADEMY 20"]
    actual = enrollments.keys
    assert_equal expected, actual
  end

  def test_load_enrollments_csv_file_and_create_enrollments_hash
    enrollments = DataLoader.new.load_enrollments_csv({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    expected = Hash
    actual = enrollments.class
    assert_equal expected, actual
  end

  def test_does_not_add_info_to_enrollments_hash_if_percentage_is_not_a_number
    enrollments = DataLoader.new.load_enrollments_csv({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_edge_cases.csv"
      }
    })
    # Two lines for AGATE 300 in test file
    # enrollments["AGATE 300"] only returns the values in the first line.
    # The second line was omitted due to #DIV/0!
    # AGATE 300,2007,Percent,1
    # AGATE 300,2006,Percent,#DIV/0!

    expected = {:kindergarten=>{2007=>1.0}}
    actual = enrollments["AGATE 300"]
    assert_equal expected, actual
  end

  def test_load_data_can_load_two_files
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/small_kg_fixture.csv",
        :high_school_graduation => "test/fixtures/small_hs_fixture.csv"
      }
    })
    expected = [:kindergarten, :high_school_graduation]
    assert_equal expected, er.enrollments.fetch("COLORADO").keys
    assert_equal 2, er.enrollments.fetch("ACADEMY 20").keys.count
  end

  def test_clean_percentage_free_or_reduced_lunch_truncates
    ep = DataLoader.new
    percent = ep.clean_percentage('0.12743', :percentage, 'Eligible for Free or Reduced Lunch')
    assert_equal 0.127, percent
  end

  def test_clean_percentage_free_lunch_only_returns_nil
    ep = DataLoader.new
    percent = ep.clean_percentage('0.08772', :percentage, 'Eligible for Free Lunch')
    assert_nil percent
  end

  def test_clean_percentage_NA_data_returns_nil
    ep = DataLoader.new
    percent = ep.clean_percentage('N/A', :percentage, 'Eligible for Free or Reduced Lunch')
    assert_nil percent
  end

  def test_clean_percentage_nil_data_returns_nil
    ep = DataLoader.new
    percent = ep.clean_percentage(nil, :percentage, 'Eligible for Free or Reduced Lunch')
    assert_nil percent
  end
end
