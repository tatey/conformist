# Conformist 

Let multiple, different input files conform to a single interface without rewriting your parser. This project is a work-in-progress.

## Usage

TODO

## Example

We have two different input files that we want to conform to the same interface. Day1.csv has a column for each of the attributes and uses a comma as the delimiter. In contrast, File2.txt combines the first and last names into a single column and uses a pipe as the delimiter.

### Input

Data is for the first three talks of days 1 and 2 from [RedDotRubyConf](http://reddotrubyconf.com/), Singapore.

#### day1.csv

    "Andy","Croll","Welcome"
    "Yukihiro","Matsumoto","The Future of Ruby"
    "Ian","McFarland","Agile the Pivotal Way"

#### day2.txt

    "Jasong Ong"|"Welcome Back"
    "Dave Thomas"|"Pragmatic Programmers"
    "Tom Preston-Warner"|"Advanced Git Techniques"

### Ruby

    require 'conformist'

    class Day1
      include Conformist::Base
      
      option :col_sep => ','
      option :quote_char => '"'
  
      column :name, 0, 1 do |values|
        values.map { |v| v.upcase } * ' '
      end
      column :talk, 2
      column :day do
        '1'
      end
    end

    class Day2
      include Conformist::Base
      
      option :col_sep => '|'
      option :quote_char => '"'

      column :name, 0 do |value|
        value.upcase
      end
      column :talk, 1
      column :day do
        '2'
      end  
    end

    Conformist.foreach File1.load('day1.csv'), File2.load('day2.txt') do |row|
      puts row      
    end
    
    # ... the above would produce the following output...

    # "{:name => 'ANDY CROLL',         :talk => 'Welcome',                 :day => '1'}"
    # "{:name => 'YUKIHIRO MATSUMOTO', :talk => 'The Future of Ruby',      :day => '1'}"
    # "{:name => 'IAN  MCFARLAND',     :talk => 'Agile the Pivotal Way',   :day => '1'}"
    # "{:name => 'JASON ONG',          :talk => 'Welcome Back',            :day => '2'}"
    # "{:name => 'DAVE THOMAS',        :talk => 'Pragmatic Programmers',   :day => '2'}"
    # "{:name => 'TOM PRESTON-WARNER', :talk => 'Advanced Git Techniques', :day => '2'}"

## Compatibility

* 1.9.2p180

## Copyright

Copyright © 2011 Tate Johnson. Conformist is released under the MIT license. See LICENSE for details.
