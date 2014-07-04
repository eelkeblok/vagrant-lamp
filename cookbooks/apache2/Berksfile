site :opscode
metadata

group :integration do
  cookbook 'apt', '~> 2.0'
  cookbook 'yum', '~> 2.0'
end

group :test do
  cookbook "apache2_test", :path => "./test/kitchen/cookbooks/apache2_test"
end

