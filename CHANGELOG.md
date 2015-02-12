# CHANGELOG

## 0.2.2 / 2015-02-12

* Don't munge headers. (@rywall)

## 0.2.1 / 2015-01-31

* Add support for named columns. (@rywall)
* Dropped support for Ruby 1.8.7, 1.9.2.

## 0.2.0 / 2012-08-18

* `Conformist::Schema#confrom` takes option to skip first row.
* Removed deprecated classes and warnings.

## 0.1.3 / 2012-02-09

* Column indexes are implicitly incremented when the index argument is omitted. Implicit indexing is all or nothing. (@coop)

## 0.1.2 / 2012-01-19

* `Conformist::Builder` coerces enumerables into an Array. Works with Spreadsheet for conforming Microsoft Excel spreadsheets.

## 0.1.1 / 2012-01-17

* Explicitly required `Forwardable`.

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
* Fixed 1.8.7 and JRuby dependencies. Gemspec will not let you specify dependencies based on the version of Ruby. Everyone gets it

## 0.0.1 / 2011-04-27

* Initial release
