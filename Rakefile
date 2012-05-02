abort "Use Ruby 1.9 to build knead" unless RUBY_VERSION["1.9"]

require 'rake-pipeline'
require 'colored'

def build
  Rake::Pipeline::Project.new("Assetfile")
end

desc "Strip trailing whitespace for CoffeeScript files in packages"
task :strip_whitespace do
  Dir["{src,test}/**/*.coffee"].each do |name|
    body = File.read(name)
    File.open(name, "w") do |file|
      file.write body.gsub(/ +\n/, "\n")
    end
  end
end

desc "Compile CoffeeScript"
task :coffeescript => :clean do
  puts "Compiling CoffeeScript"
  `coffee -co lib/ src/`
  puts "Done"
end

desc "Build knead"
task :dist => [:coffeescript, :strip_whitespace] do
  puts "Building knead..."
  build.invoke
  puts "Done"
end

desc "Clean build artifacts from previous builds"
task :clean do
  puts "Cleaning build..."
  `rm -rf ./lib/*`
  build.clean
  puts "Done"
end

desc "Run tests with phantomjs"
task :test => :dist do |t, args|
  unless system("which phantomjs > /dev/null 2>&1")
    abort "PhantomJS is not installed. Download from http://phantomjs.org"
  end

  cmd = "phantomjs test/qunit/run-qunit.js \"file://localhost#{File.dirname(__FILE__)}/test/index.html\""

  # Run the tests
  puts "Running tests"
  puts cmd
  success = system(cmd)

  if success
    puts "Tests Passed".green
  else
    puts "Tests Failed".red
    exit(1)
  end
end

desc "upload versions"
task :upload => :test do
  load "./version.rb"
  uploader = GithubUploader.setup_uploader
  GithubUploader.upload_file uploader, "knead-#{KNEAD_VERSION}.js", "knead #{KNEAD_VERSION}", "dist/knead.js"
  GithubUploader.upload_file uploader, "knead-#{KNEAD_VERSION}-spade.js", "knead #{KNEAD_VERSION} (minispade)", "dist/knead-spade.js"
  GithubUploader.upload_file uploader, "knead-#{KNEAD_VERSION}.html", "knead #{KNEAD_VERSION} (html_package)", "dist/knead.html"

  GithubUploader.upload_file uploader, 'knead-latest.js', "Current knead", "dist/knead.js"
  GithubUploader.upload_file uploader, 'knead-latest-spade.js', "Current knead (minispade)", "dist/knead-spade.js"
end

desc "tag/upload release"
task :release, [:version] => :test do |t, args|
  unless args[:version] and args[:version].match(/^[\d]+\.[\d]+\.[\d].*$/)
    raise "SPECIFY A VERSION curent version: #{KNEAD_VERSION}"
  end
  File.open("./version.rb", "w") do |f| 
    f.write %|KNEAD_VERSION = "#{args[:version]}"|
  end

  system "git add version.rb"
  system "git commit -m 'bumped version to #{args[:version]}'"
  system "git tag #{args[:version]}"
  system "git push origin master"
  system "git push origin #{args[:version]}"
  Rake::Task[:upload].invoke
end