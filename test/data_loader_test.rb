require 'data_loader'
require 'test_helper'

class DataLoaderTest < Minitest::Test
  def test_data_loader_can_take_in_a_file
    set = DataLoader.new.load_csv({
      :enrollment => {
        :kindergarten => "test/fixtures/kindergarten_fixture.csv"
      }
    }, 'districts')
    assert_equal 2, set.count
  end
end
