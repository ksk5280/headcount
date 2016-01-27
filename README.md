# Headcount

## Turing School: Module 1, Final Project

### Kimiko Kano and David Whitaker

[Original assignment](https://github.com/turingschool/curriculum/blob/master/source/projects/headcount.markdown)

### Project Overview

In this project, Colorado school data was analyzed to see what we could learn about education around the state. The data was divided into multiple CSV files, with a __District__ being the unifying piece of information across the various data files. The files could be categorized into three groups:

* __Enrollment__ - Information about enrollment rates across various
grade levels in each district
* __Statewide Testing__ - Information about test results in each district
broken down by grade level, race, and ethnicity
* __Economic Profile__ - Information about socioeconomic profiles of
students and within districts

Starting with the CSV data we:
* built a "Data Access Layer" which allows us to query/search the underlying data
* built a "Relationships Layer" which creates connections between related data
* built an "Analysis Layer" which uses the data and relationships to draw conclusions

#### District Class
A district is created when you call the ```find_by_name``` method in the ```DistrictRepository``` class.

* A ```DistrictRepository``` object is created and the ```load_data``` method is called on it.
```ruby
  dr = DistrictRepository.new
  dr.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv"
    }
  })
  district = dr.find_by_name('COLORADO')
  ```
* In this example, when the ```load_data``` method is called:
  1. An ```EnrollmentRepository``` object is created
  2. The csv data is loaded by the ```DataLoader``` class
  3. ```DataLoader``` parses the data into an enrollments hash.

* the following ```data``` is passed into the ```District``` object as an argument, creating a ```name``` and an ```enrollment```:
```ruby
  {:name => "COLORADO",
   :enrollment =>
    #<Enrollment:0x007fb53c1ab5c8
     @high_school_graduation=
      {
       2010=>0.724,
       2011=>0.739,
       2012=>0.75354,
       2013=>0.769,
       2014=>0.773
      },
     @kindergarten_participation=
      {
       2007=>0.39465,
       2006=>0.33677,
       2005=>0.27807,
       2004=>0.24014,
       2008=>0.5357,
       2009=>0.598,
       2010=>0.64019,
       2011=>0.672,
       2012=>0.695,
       2013=>0.70263,
       2014=>0.74118
      },
     @name="COLORADO">
  }
```
* Data for creating a Statewide Test Repository and Economic Profile Repository can be loaded in a similar manner.

#### HeadcountAnalyst Class

The HeadcountAnalyst Class contains the following methods:

##### Kindergarten Participation Rate Variation Between Districts

`.kindergarten_participation_rate_variation(district1_name, :against => district2_name)`

=> returns the first district's average divided by the second district's average.

##### Kindergarten Participation Rate Variation Compared to the State Average

`.kindergarten_participation_rate_variation(district1_name, :against => 'COLORADO')`

=> returns a district's average compared against the state average.

##### Kindergarten Participation Rate Trend

`.kindergarten_participation_rate_variation_trend(district_name, :against => 'COLORADO')`

=> returns a hash of the averages broken down for each year

##### Kindergarten Participation Compared to High School Graduation

`.kindergarten_participation_against_high_school_graduation(district_name)`

=> returns the quotient of kindergarten variation and high school graduation variation, where the variation is the quotient of a district's participation compared to the statewide average.

##### Kindergarten Participation vs. High School Graduation Correlation

`.kindergarten_participation_correlates_with_high_school_graduation(for: district_name)`

=> returns true if the correlation is between 0.6 and 1.5

=> if the `district_name` is `STATEWIDE`, returns true if over 70% of districts have a correlation.

=> the correlation can also be performed `:across` an array of districts.

##### Statewide Test Year Over Year Growth

`.top_statewide_test_year_over_year_growth(data)`

This method takes in data which can be in different forms:

##### Finding a single leader

```ruby
ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
=> ['the top district name', 0.123]
```

Where `0.123` is their average percentage growth across years. If there are three years of proficiency data (year1, year2, year3), that's `((proficiency at year3) - (proficiency at year1)) / (year3 - year1)`.

##### Finding multiple leaders

Let's say we want to be able to find several top districts using the same calculations:

```ruby
ha.top_statewide_test_year_over_year_growth(grade: 3, top: 3, subject: :math)
=> [['top district name', growth_1], ['second district name', growth_2], ['third district name', growth_3]]
```

Where `growth_1` through `growth_3` represents their average growth across years.

##### Across all subjects

What about growth across all three subject areas?

```ruby
ha.top_statewide_test_year_over_year_growth(grade: 3)
=> ['the top district name', 0.111]
```

Where `0.111` is the district's average percentage growth across years across subject areas.

But that considers all three subjects in equal proportion. No Child Left Behind guidelines generally emphasize reading and math, so let's add the ability to weight subject areas:

```ruby
ha.top_statewide_test_year_over_year_growth(grade: 8, :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.0})
=> ['the top district name', 0.111]
```

Assuming we have a `dr` that's an instance of `DistrictRepository`, a `HeadcountAnalyst` is initialized like this:

```ruby
ha = HeadcountAnalyst.new(dr)
```

### Testing
This project was developed using Test Driven Development. There are 116 tests in total that can be run using [mrspec](https://github.com/JoshCheek/mrspec). Run the command `mrspec` from the terminal in the project's root directory.
