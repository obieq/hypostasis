#!/usr/bin/env ruby

require 'hypostasis'
require 'ffaker'
require 'benchmark'

begin
  Hypostasis::Connection.create_namespace 'performance_documents', data_model: :document
  Hypostasis::Connection.create_namespace 'performance_columns', data_model: :column_group
rescue Hypostasis::Errors::NamespaceAlreadyCreated
end

class SampleDocument
  include Hypostasis::Document

  use_namespace 'performance_documents'

  field :name
  field :age
  field :dob

  field :notes
end

class SampleColumnGroup
  include Hypostasis::ColumnGroup

  use_namespace 'performance_columns'

  field :name
  field :age
  field :dob

  field :notes
end

[10, 100, 1000].each do |batch_size|
  document_batch = []
  columns_batch = []
  batch_size.times do
    name  = Faker::Name.name
    age   = (19..99).to_a.shuffle.first
    dob   = Date.today.prev_year(age)
    notes = Faker::Lorem.sentences((3..10).to_a.shuffle.first).join(' ')

    document_batch << SampleDocument.new(name: name, age: age, dob: dob, notes: notes)
    columns_batch << SampleColumnGroup.new(name: name, age: age, dob: dob, notes: notes)
  end

  puts "Batch size of #{batch_size} saves:\n"
  Benchmark.bm do |b|
    b.report('documents:     ') { document_batch.each {|doc| doc.save}}
    b.report('column_groups: ') { columns_batch.each {|doc| doc.save}}
  end
  puts "\n"

  document_batch.collect! {|doc| doc.id}
  columns_batch.collect! {|doc| doc.id}

  puts "Batch size of #{batch_size} finds:\n"
  Benchmark.bm do |b|
    b.report('documents:     ') { document_batch.each {|doc| SampleDocument.find doc}}
    b.report('column_groups: ') { columns_batch.each {|doc| SampleColumnGroup.find doc}}
  end
  puts "\n\n\n"
end

Hypostasis::Connection.destroy_namespace 'performance_documents'
Hypostasis::Connection.destroy_namespace 'performance_columns'
