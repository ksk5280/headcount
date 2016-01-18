require_relative 'economic_profile'
require_relative 'data_loader'

class EconomicProfileRepository
  attr_reader :economic_profile

  def load_data(data)
    @economic_profile = DataLoader.new.load_economic_csv(data)
  end

  def find_by_name(name)
    name = name.upcase
    if economic_profile.has_key?(name)
      EconomicProfile.new({
        :name => name,
        :median_household_income => economic_profile.fetch(name)[:median_household_income],
        :children_in_poverty => economic_profile.fetch(name)[:children_in_poverty],
        :free_or_reduced_price_lunch => economic_profile.fetch(name)[:free_or_reduced_price_lunch],
        :title_i => economic_profile.fetch(name)[:title_i]
      })
    end
  end
end
