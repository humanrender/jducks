#!/usr/bin/ruby

require "./jducks/lib/jducks.rb"

JDucks.conf do |conf|
  conf.project_name = "Testsuite"
  conf.files = "example/app/**/*.js"
  conf.dir = "example/docs"
  conf.docs_dir = "example/app/docs"
end

JDucks.build