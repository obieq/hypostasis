# Hypostasis

[![Gem Version](https://badge.fury.io/rb/hypostasis.png)](http://badge.fury.io/rb/hypostasis)
[![Build Status](https://travis-ci.org/hypostasis/hypostasis.png)](https://travis-ci.org/hypostasis/hypostasis)
[![Code Climate](https://codeclimate.com/github/hypostasis/hypostasis.png)](https://codeclimate.com/github/hypostasis/hypostasis)
[![Dependency Status](https://gemnasium.com/hypostasis/hypostasis.png)](https://gemnasium.com/hypostasis/hypostasis)

Hypostasis is a layer for FoundationDB that supports multiple data models on
top of the incredibly powerful key-value system provided by FoundationDB. The
goal of Hypostasis is to provide robust ways of representing different kinds of
application data in Ruby and mapping them to FoundationDB cleanly.

## Data Models

Applications have many different ways of representing data, some work well with
relational approaches, and some work better with document-oriented ones. Since
FoundationDB doesn't enforce a rigid data model it is possible to support a
variety of data models while using the same underlying storage system, provided
by FoundationDB. The data models Hypostasis currently aims to support are the
following:

* Key-Value
* Column Group
* Document


## Installation

Add this line to your application's Gemfile:

    gem 'hypostasis'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hypostasis

## Usage

Hypostasis is beta quality software, please keep this in mind. Until the first
major version is released the API is not to be considered stable. Feel free to
play around with it and open issues for anything you find that causes a problem
or for any features you want to see added.

Until then, we suggest reading the code and the tests.

### Key-Value Data Model

    require 'hypostasis'

    ns = Hypostasis::Connection.create_namespace('keystore', {data_model: :key_value})
    ns.set('keyname', 10)

    ns.get('keyname')     #=> 10

The Key-Value data model provides some simple enhancements on top of
FoundationDB's core key-value capabilities, including automatic reconstitution
of basic language types and support for namespacing where keys are stored. The
basic language types currently suported include the following:

* String
* Fixnum
* Bignum
* Float
* Date
* DateTime
* Time
* Boolean

### ColumnGroup Data Model

    require 'hypostasis'

    ns = Hypostasis::Connection.create_namespace('keystore', {data_model: :column_group})

    class SampleColumnGroup
      include Hypostasis::ColumnGroup

      field :name
      field :age
      field :dob

      index :name
      index :age
    end

    SampleColumnGroup.create(name: 'John', age: 21, dob: Date.today.prev_year(21))

    SampleColumnGroup.find(<<id>>)

    SampleColumnGroup.find_where(name: 'John')
    SampleColumnGroup.find_where(age: 21)

The Column Group data model provides a data model very similar to what would be
provided by a traditional RDBMS or Column-Family data store with data organized
along the idea of tables and rows, but mapped directly to the underlying
key-value store of FoundationDB. Like the other data models, the Column Group
model is able to automatically encode and reconstitute certain basic Ruby data
types, including the following:

* String
* Fixnum
* Bignum
* Float
* Date
* DateTime
* Time
* Boolean

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
