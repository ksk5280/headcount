$LOAD_PATH.unshift(File.expand_path('.',__dir__))
require 'enrollment_repository'
require 'pry'

class Enrollment
  attr_reader :name,
              :kindergarten_participation,
              :high_school_graduation

  def initialize(data)
    @name = data[:name].upcase
    @kindergarten_participation =
      data[:kindergarten_participation]
      #maybe add instance_var of high_school_graduation?
    @high_school_graduation =
      data[:high_school_graduation]
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
