$LOAD_PATH.unshift(File.expand_path('.',__dir__))
require 'enrollment_repository'
require 'pry'

class Enrollment
  attr_reader :name,
              :kindergarten_participation

  def initialize(data)
    @name = data[:name].upcase
    @kindergarten_participation =
      data[:kindergarten_participation]
  end

  def kindergarten_participation_by_year
    kindergarten_participation.each do |k, v|
      kindergarten_participation[k] = v.round(3)
    end
    # returns a hash with keys as years and values as truncated percentage
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year.fetch(year)
  end
end

if __FILE__ == $0
end
