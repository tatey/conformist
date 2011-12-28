# Conformist 

Caution! Work in progress.

# 1.0.0

## Goals

* Remove dependancy on IO. Should be able to work with anything that quacks 
like a collection. We shouldn't care how that collection got there.
* Anonymous, inline definitions. No need to create an entire class.
* Lazy. Should work well with large collections.
* Quick and easy way of reading a file from disk. This is the most common use case.

## Examples

Anonymous definition

``` ruby
citizen = Conformist.new do
  column :name, 0, 1
  column :email, 2
end

citizen.conform []
```

Class definition. Declarative and maintains compatibility with earlier versions.

``` ruby
class Citizen
  include Conformist
  
  column :name, 0, 1
  column :email, 2
end

Citizen.conform CSV.new(File.open('/path/to/file', 'r'))
```

Lazy. Collection is not evaluated until you call #each or #map.

``` ruby
definition.conform(collection).each
definition.conform(collection).map 
```

# 0.0.3

Conformist lets you bend CSVs to your will. Let multiple, different input files conform to a single interface without rewriting your parser each time.

Motivation for this project came from the desire to simplify importing data from various government organisations into [Antenna Mate](http://antennamate.com). The data from each government was similar, but had completely different formatting. Some pieces of data needed preprocessing while others simply needed to be concatenated together. I did not want to write a new parser for each new government organisation. Instead, I created Conformist.

## Installation

Conformist is available from rubygems.org.

``` sh
$ gem install conformist
```

## Usage

You create a Ruby class, mix-in `Conformist::Base` and declare how an input file should map to a single interface.

``` ruby
require 'conformist'

class Citizen1
  include Conformist::Base
    
  column :name, 0, 1
  column :city, 2 do |value|
    value.upcase
  end
end

class Citizen2
  include Conformist::Base
  
  column :name, 0
  column :city, 1
end
```

Load up your definitions and enumerate over each row in the input file.

``` ruby
Conformist.foreach Citizen1.load('citizens1.csv'), Citizen2.load('citizens2.csv') do |row|
  Citizen.create! row
end
```

Each object passed into the block will be a hash. Perfect for passing to a model to save into a datastore (Or whatever tickles your fancy).

### Option

Conformist uses CSV (Formally FasterCSV) to perform the heavy lifting. You can declare options that should be passed to CSV at runtime. It is safe to call `option` multiple times.

``` ruby
option :col_sep => ','
option :quote_char => '"'
```

### One Column

Maps the first column in the input file to the `:first_name` key-value pair. Indexing starts at zero.

``` ruby
column :first_name, 0
```

### Many Columns

Maps the first and second columns in the input file to the `:name` key-value pair and implicitly concatenates the values.

``` ruby
column :name, 0, 1
```

Indexing is completely arbitrary and you can map any combination.

``` ruby
column :name_and_city 0, 2
```

### Preprocessing

Sometimes you will want to manipulate values before they're conformed. You can pass a block and get access to the values. The return value of the expression becomes the conformed output.

``` ruby
column :name, 0, 1 do |values|
  values.map { |v| v.upcase } * ' '
end
```

Works with one column too. Instead of getting an array of strings, you get one string.

``` ruby
column :first_name, 0 do |value|
  value.upcase
end
```

### Virtual Columns

Declare a column you want included in the conformed output that is not based on the input file. This is useful when you need to set values based on the conformist definition. 

``` ruby
column :day do 
  1
end
```

### Inheritance

Inheriting from a class which mixes in Conformist::Base gives you access to all of the superclasses' columns.

``` ruby
class Citizen
  include Conformist::Base

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

Adult.load('adults.csv').foreach do |row|
  row # => {:name => 'Tate Johnson', :category => 'Adult}
end
```
## Example

* https://gist.github.com/949576

## Compatibility

* 1.9.2-p180
* 1.8.7-p334
* jruby-1.6.1

## Contributing

Patches welcome! 

1. Fork the repository
2. Create a topic branch
3. Write tests and make changes
4. Make sure the tests pass by running `rake`
5. Push and send a pull request on GitHub

## Copyright

Copyright © 2011 Tate Johnson. Conformist is released under the MIT license. See LICENSE for details.
