require_relative 'economic_profile'
require_relative 'data_loader'

class EconomicProfileRepository
  attr_reader :economic_profiles

  def load_data(data)
    @economic_profiles = DataLoader.new.load_economic_csv(data)
  end

  def find_by_name(name)
    name = name.upcase
    if economic_profiles.has_key?(name)
      EconomicProfile.new({
        :name => name,
        :median_household_income =>
          economic_profiles.fetch(name)[:median_household_income],
        :children_in_poverty =>
          economic_profiles.fetch(name)[:children_in_poverty],
        :free_or_reduced_price_lunch =>
          economic_profiles.fetch(name)[:free_or_reduced_price_lunch],
        :title_i => economic_profiles.fetch(name)[:title_i]
      })
    end
  end
end
