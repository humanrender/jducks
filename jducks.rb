#!/usr/bin/ruby

require "./jducks/lib/jducks.rb"

JDucks.conf do |conf|
  conf.project_name = "Testsuite"
  conf.project_description = "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Expedita, officiis, facilis sunt doloribus necessitatibus distinctio eos qui laborum numquam quam quas reiciendis sequi vel nisi asperiores! Animi, voluptate in voluptatibus!"
  conf.files = "example/app/**/*.js"
  conf.dir = "example/docs"
  conf.docs_dir = "example/app/docs"
end

JDucks.build