# CHANGELOG

## 0.1.0 / 2012-01-05

* Added anonymous schemas.
* Added `Conformist::Schema::Methods#conform` for lazily applying schema to input.
* Added capability to access columns with methods.
* FasterCSV is no longer included, use `require 'fastercsv'` instead.
* `include Conformist::Base` has been removed.
* `Conformist.foreach` has been removed.
* `Conformist::Base::ClassMethods#load` has been removed.

## 0.0.3 / 2011-05-07

* Inheriting from a class which mixes in Conformist::Base gives you access to all of the superclasses' columns.

## 0.0.2 / 2011-04-28

* Column#values_in will be nil if the index is out of range rather than an empty string. This is consistent with CSV
* Fixed 1.8.7 and JRuby dependancies. Gemspec will not let you specify dependancies based on the version of Ruby. Everyone gets it

## 0.0.1 / 2011-04-27

* Initial release
