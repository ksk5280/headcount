# Headcount

## Turing School: Module 1, Project 6

[Original assignment](https://github.com/turingschool/curriculum/blob/master/source/projects/headcount.markdown)


##### District Class:
A district is only created when you call the ```find_by_name``` method in the ```DistrictRepository``` class.


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
* When the ```load_data``` method is called:
  1. An ```EnrollmentRepository``` object is created
  2. The csv data is loaded by the ```DataLoader``` class
  3. ```DataLoader``` parses the data into the hash in the correct format.
* , which creates and enrollments hash into which the data is stored.


* loads the kindergarten and high school data into a hash
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

In HeadcountAnalyst Class:
```ruby
  district_repos.districts =
    {"COLORADO"=>
      {:kindergarten=>
        {2007=>0.39465,
         2006=>0.33677,
         2005=>0.27807,
         etc...      },
       :high_school_graduation=>
        {2010=>0.724,
         2011=>0.739,
         2012=>0.75354,
         etc...      },
      },
     "ACADEMY 20"=>
      {:kindergarten=>
        {2007=>0.39159,
         2006=>0.35364,
         2005=>0.26709,
         etc...      },
       :high_school_graduation=>
        {2010=>0.895,
         2011=>0.895,
         2012=>0.88983
         etc...      },
      },
      etc...
    }
```
