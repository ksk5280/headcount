require 'data_loader'
require 'test_helper'

class DataLoaderTest < Minitest::Test
  def test_data_loader_can_take_in_a_file
    hash = DataLoader.new.load_csv({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    assert_equal 2, hash.count
  end

  def test_load_csv_file_and_create_enrollments_hash
    skip
    hash = DataLoader.new.load_csv({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    })
    expected = "what does it return?"
    actual = hash.values
    assert_equal expected, actual
  end

  def test_what_happens_if_file_does_not_exist?
    skip
    hash = DataLoader.new.load_csv({
      :enrollment => {
        :kindergarten => "test/fixtures/pizza.csv"
      }
    })
    expected = "what does it return?"
    actual = "actual"
    assert_equal expected, actual
  end


end
