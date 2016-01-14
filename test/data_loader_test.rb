require 'data_loader'
require 'test_helper'

class DataLoaderTest < Minitest::Test
  def test_data_loader_can_take_in_a_file
    enrollments = DataLoader.new.load_csv({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    assert_equal 2, enrollments.count
  end

  def test_load_csv_file_and_create_enrollments_keys
    enrollments = DataLoader.new.load_csv({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    expected = ["COLORADO", "ACADEMY 20"]
    actual = enrollments.keys
    assert_equal expected, actual
  end

  def test_load_csv_file_and_create_enrollments_hash
    enrollments = DataLoader.new.load_csv({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    expected = Hash
    actual = enrollments.class
    assert_equal expected, actual
  end

  def test_does_not_add_info_to_enrollments_hash_if_percentage_is_not_a_number
    enrollments = DataLoader.new.load_csv({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_edge_cases.csv"
      }
    })
    # Two lines for AGATE 300 in test file
    # enrollments["AGATE 300"] only returns the values in the first line.
    # The second line was omitted due to #DIV/0!
    # AGATE 300,2007,Percent,1
    # AGATE 300,2006,Percent,#DIV/0!

    expected = {2007=>1.0}
    actual = enrollments["AGATE 300"]
    assert_equal expected, actual
  end

end
