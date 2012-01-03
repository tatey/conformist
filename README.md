# Conformist 

Conformist lets you bend CSVs to your will. Let multiple, different input files conform to a single interface without rewriting your parser each time.

Motivation for this project came from the desire to simplify importing data from various government organisations into [Antenna Mate](http://antennamate.com). The data from each government was similar, but had completely different formatting. Some pieces of data needed preprocessing while others simply needed to be concatenated together. I did not want to write a new parser for each new government organisation. Instead, I created Conformist.

## Quick and Dirty

Open a CSV file and declare a schema.

``` ruby
require 'csv'
require 'conformist'

csv    = CSV.open '~/transmitters.csv'
schema = Conformist.new do
  column :callsign, 1
  column :latitude, 1, 2, 3
  column :longitude, 3, 4, 5
  column :name, 0 do |value|
    value.upcase
  end
end
```

Insert the transmitters into a SQLite database.

``` ruby
require 'sqlite3'

db = SQLite3::Database.new 'transmitters.db'
schema.conform(csv).each do |transmitter|
  db.execute "INSERT INTO transmitters (callsign, ...) VALUES ('#{transmitter.callsign}', ...);"
end
```

Only insert the transmitters with the name "Mount Cooth-tha" using ActiveRecord.

``` ruby
transmitters = schema.conform(csv).select do |transmitter|
  transmitter.name == 'Mount Coot-tha'
end
transmitter.each do |transmitter|
  Transmitter.create! transmitter.attributes
end
```

Let multiple, different input files conform to a single interface without rewriting your parser each time.

``` ruby
[schema1.conform(csv1), schema2.conform(csv2), schema3.conform(csv3)].each do |schema|
  schema.each do |transmitter|
    # ...
  end
end
```

## Installation

Conformist is available as a gem. Install it at the command line.

``` sh
$ [sudo] gem install conformist
```

Or add it to your Gemfile and run `$ bundle install`.

``` ruby
gem 'conformist'
```

## Usage

### Anonymous Schema

``` ruby
citizen = Conformist.new do
  column :name, 0, 1
  column :email, 2
end

citizen.conform [['Tate', 'Johnson', 'tate@tatey.com']]
```

### Class Schema

Class schemas were the only schemas supported in earlier versions.

``` ruby
class Citizen
  extend Conformist
  
  column :name, 0, 1
  column :email, 2
end

Citizen.conform [['Tate', 'Johnson', 'tate@tatey.com']]
```

### Conform

`#conform` is lazy, returning an [Enumerator](http://www.ruby-doc.org/core-1.9.3/Enumerator.html). That means schemas can be setup now and evaluated later. 

``` ruby
enumerable1 = schema.conform CSV.open('~/file.csv') # CSV
enumerable2 = schema.conform [[], [], []]           # Array of arrays
```

A schema is evaluated when `#each`, `#map` or any method defined in [Enumerable](http://www.ruby-doc.org/core-1.9.3/Enumerable.html) is calledd. `#conform` accepts any object that responds to `#each`.

``` ruby
enumerable1.each &block # Each has the lowest memory footprint because it doesn't build a collection
enumerable2.map &block
```

Passed into the block is a Struct-like object. You can access keys like you would a hash or you can access attributes like you would an object. The latter is the preferred syntax.

``` ruby
citizen[:name] # => Tate Johnson
citizen.name   # => Tate Johnson
```

### One Column

Maps the first column in the input file to `:first_name`. Column indexing starts at zero.

``` ruby
column :first_name, 0
```

### Many Columns

Maps the first and second columns in the input file to `:name`.

``` ruby
column :name, 0, 1
```

Indexing is completely arbitrary and you can map any combination.

``` ruby
column :name_and_city 0, 1, 2
```

Many columns are implicitly concatenated. Behaviour can be changed by passing a block. See *preprocessing*.

### Preprocessing

Sometimes values need to be manipulated before they're conformed. Passing a block gets access to values. The return value of the block becomes the conformed output.

``` ruby
column :name, 0, 1 do |values|
  values.map { |v| v.upcase } * ' '
end
```

Works with one column too. Instead of getting a collection of objects, one object is passed to the block.

``` ruby
column :first_name, 0 do |value|
  value.upcase
end
```

### Virtual Columns

Columns do not have to be sourced from input. Omit the index and a virtual column is included in the conformed output.

``` ruby
column :day do 
  1
end
```

### Inheritance

Inheriting from a schema gives access to all of the parent schema's columns.

#### Anonymous Schema

``` ruby
citizen = Conformist.new do
  column :name, 0, 1
end

adult = Conformist.new citizen do
  column :category do
    'Adult'
  end
end

child = Conformist.new citizen do
  column :category do
    'Child'
  end
end
```

#### Class Schema

``` ruby
class Citizen
  extend Conformist

  column :name, 0, 1
end

class Adult < Citizen
  column :category do
    'Adult'
  end
end

class Child < Citizen
  column :category do
    'Child'
  end
end
```

## 0.0.3 to 0.1.0

### Changes

* `include Conformist::Base` is deprecated, use `extend Conformist` instead.
* `Conformist.foreach` has is deprecated.
* `Conformist.load` is deprecated.
* FasterCSV is no longer bundled. Require it yourself or prefer `CSV` from the standard library when using 1.9.X.

### Upgrading

Where previously you had

``` ruby
class Citizen
  include Conformist::Base

  column :name, 0, 1
end

Citizen.load('~/file.csv').foreach do |citizen|
  # ...
end
```

You should now do

``` ruby
require 'csv' # or 'fastercsv' when not using 1.9.X

class Citizen
  extend Conformist

  column :name, 0, 1
end

Citizen.conform(CSV.open('~/file.csv')).each do |citizen|
  # ...
end
```

## Compatibility

* 1.9
* 1.8.7
* JRuby

## Copyright

Copyright © 2011 Tate Johnson. Conformist is released under the MIT license. See LICENSE for details.
