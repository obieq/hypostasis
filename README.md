# Hypostasis

[![Build Status](https://travis-ci.org/hypostasis/hypostasis.png)](https://travis-ci.org/hypostasis/hypostasis)
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

* Document-Oriented
* Simple Key-Value (Wrapper for naked FoundationDB)
* Relational (an RDBMS without SQL)
* Column-Oriented (like Cassandra without CQL)

The initial focus will be on the Document-Oriented and simple Key-Value models.

## Installation

Add this line to your application's Gemfile:

    gem 'hypostasis'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hypostasis

## Usage

Hypostasis is still very much Alpha quality software, only suitable for
experimentation. But, feel free to play around with it. Documentation will be
written to define how to use the various data models provided by Hypostasis as
the project matures and the APIs stabilize.

Until then, we suggest reading the code and the tests.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
