#!/usr/bin/ruby

require "./jducks/lib/jducks.rb"

JDucks.conf do |conf|
  conf.project_name = "Testsuite"
  conf.files = "example/**/*.js"
  conf.dir = "docs"
end

JDucks.build