# Conformist 

Conformist lets you bend CSVs to your will. Let multiple, different input files conform to a single interface without rewriting your parser each time.

Motivation for this project came from the desire to simplify importing data from various government organisations into [Antenna Mate](http://antennamate.com). The data from each government was similar, but had completely different formatting. Some pieces of data needed preprocessing while others simply needed to be concatenated together. I did not want to write a new parser for each new government organisation. Instead, I created Conformist.

## Usage

You create a Ruby class, mix-in `Conformist::Base` and declare how an input file should map to a single interface.

``` ruby
require 'conformist'

class Citizen1
  include Conformist::Base
    
  column :name, 0, 1
  column :address, 2 do |value|
    value.upcase
  end
end

class Citizen2
  include Conformist::Base
  
  column :name, 0
  column :address, 1
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
column :name_and_address, 0, 2
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

## Compatibility

* 1.9.2p180

## Copyright

Copyright © 2011 Tate Johnson. Conformist is released under the MIT license. See LICENSE for details.
