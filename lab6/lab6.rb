# frozen_string_literal: true
require './lab6/Enigma'
require_relative 'Enigma'

machine = Enigma::Machine.new
puts a = machine.convert('TEXTEXTEXTEXTEXTEXT')
machine.reset!
puts machine.convert(a)
