ruby "2.2.2"

source "https://rubygems.org"

# Framework
gem "sinatra", "~> 1.4"

# Web server
gem "puma", "~> 2.13"

# API wrappers
gem "plaid", "~> 1.6"
gem "clearbit", "~> 0.1"
gem "vcr"
gem "webmock"

# Misc
gem "dotenv", "~> 2.0"
gem "celluloid", "~> 0.16"

group :development, :test do
  gem "pry"
end

group :test do
  gem "minitest", "~> 5.8"
  gem "minitest-hooks"
  gem "rack-test"
  gem "rspec-mocks"
end
