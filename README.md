# Conformist 

[![Build Status](https://secure.travis-ci.org/tatey/conformist.png)](http://travis-ci.org/tatey/conformist)

Bend CSVs to your will. Stop using array indexing and start using declarative schemas. Declarative schemas are easier to understand, quicker to setup and independent of I/O.

![](http://f.cl.ly/items/00191n3O1J2E1a342F1L/conformist.jpg)

## Quick and Dirty Examples

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

Only insert the transmitters with the name "Mount Cooth-tha" using ActiveRecord or DataMapper.

``` ruby
transmitters = schema.conform(csv).select do |transmitter|
  transmitter.name == 'Mount Coot-tha'
end
transmitter.each do |transmitter|
  Transmitter.create! transmitter.attributes
end
```

Source from multiple, different input files and insert transmitters together into a single database.

``` ruby
require 'csv'
require 'conformist'
require 'sqlite3'

au_schema = Conformist.new do
  column :callsign, 8
  column :latitude, 10
end
us_schema = Conformist.new do
  column :callsign, 1
  column :latitude, 1, 2, 3
end

au_csv = CSV.open '~/au/transmitters.csv'
us_csv = CSV.open '~/us/transmitters.csv'

db = SQLite3::Database.new 'transmitters.db'

[au_schema.conform(au_csv), us_schema.conform(us_csv)].each do |schema|
  schema.each do |transmitter|
    db.execute "INSERT INTO transmitters (callsign, ...) VALUES ('#{transmitter.callsign}', ...);"
  end
end
```

For **more examples** see `test/fixtures`, `test/schemas` and `test/unit/integration_test.rb`.

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

Anonymous schemas are quick to declare and don't have the overhead of creating an explicit class.

``` ruby
citizen = Conformist.new do
  column :name, 0, 1
  column :email, 2
end

citizen.conform [['Tate', 'Johnson', 'tate@tatey.com']]
```

### Class Schema

Class schemas are explicit. Class schemas were the only type available in earlier versions of Conformist.

``` ruby
class Citizen
  extend Conformist
  
  column :name, 0, 1
  column :email, 2
end

Citizen.conform [['Tate', 'Johnson', 'tate@tatey.com']]
```

### Conform

Conform is the principle method for lazily applying a schema to the given input.

``` ruby
enumerator = schema.conform CSV.open('~/file.csv')
enumerator.each do |row|
  puts row.attributes
end
```

#### Input

`#conform` expects any object that responds to `#each` to return an array-like object.

``` ruby
CSV.open('~/file.csv').responds_to? :each # => true
[[], [], []].responds_to? :each           # => true
```

#### Enumerator

`#conform` is lazy, returning an [Enumerator](http://www.ruby-doc.org/core-1.9.3/Enumerator.html). Input is not parsed until you call `#each`, `#map` or any method defined in [Enumerable](http://www.ruby-doc.org/core-1.9.3/Enumerable.html). That means schemas can be assigned now and evaluated later. `#each` has the lowest memory footprint because it does not build a collection.

#### Struct

The argument passed into the block is a struct-like object. You can access columns as methods or keys. Columns were only accessible as keys in earlier versions of Conformist. Methods are now the preferred syntax.

``` ruby
citizen[:name] # => "Tate Johnson"
citizen.name   # => "Tate Johnson"
```

For convenience the `#attributes` method returns a hash of key-value pairs suitable for creating ActiveRecord or DataMapper records.

``` ruby
citizen.attributes # => {:name => "Tate Johnson", :email => "tate@tatey.com"}
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
  values.map(&:upcase) * ' '
end
```

Works with one column too. Instead of getting a collection of objects, one object is passed to the block.

``` ruby
column :first_name, 0 do |value|
  value.upcase
end
```

### Virtual Columns

Virtual columns are not sourced from input. Omit the index to create a virtual column. Like real columns, virtual columns are included in the conformed output.

``` ruby
column :day do 
  1
end
```

### Inheritance

Inheriting from a schema gives access to all of the parent schema's columns.

#### Anonymous Schema

Anonymous inheritance takes inspiration from Ruby's syntax for [instantiating new classes](http://ruby-doc.org/core-1.9.3/Class.html#method-c-new).

``` ruby
parent = Conformist.new do
  column :name, 0, 1
end

child = Conformist.new parent do
  column :category do
    'Child'
  end
end
```

#### Class Schema

Classical inheritance works as expected.

``` ruby
class Parent
  extend Conformist

  column :name, 0, 1
end

class Child < Citizen
  column :category do
    'Child'
  end
end
```

## Upgrading from <= 0.0.3 to 0.1.0

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
require 'fastercsv'

class Citizen
  extend Conformist

  column :name, 0, 1
end

Citizen.conform(CSV.open('~/file.csv')).each do |citizen|
  # ...
end
```

See CHANGELOG.md for a full list of changes.

## Compatibility and Dependancies

* MRI 1.9.2+
* MRI 1.8.7
* JRuby 1.6.5

Conformist has no explicit dependencies, although `CSV` or `FasterCSV` is commonly used.

## Motivation

Motivation for this project came from the desire to simplify importing data from various government organisations into [Antenna Mate](http://antennamate.com). The data from each government was similar, but had completely different formatting. Some pieces of data needed preprocessing while others simply needed to be concatenated together. Not wanting to write a parser for each new government organisation, I created Conformist.

## Copyright

Copyright © 2011 Tate Johnson. Conformist is released under the MIT license. See LICENSE for details.
