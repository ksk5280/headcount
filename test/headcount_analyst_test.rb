require 'headcount_analyst'
require 'test_helper'

class HeadcountAnalystTest < Minitest::Test
  def test_class_exists
    HeadcountAnalyst.new
    assert HeadcountAnalyst
  end
end
