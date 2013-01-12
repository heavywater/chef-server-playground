current_dir = File.dirname(__FILE__)
cache_dir = File.join(current_dir, %w[ .. cache ])

log_level                :info
log_location             STDOUT
node_name                "root"
client_key               "#{cache_dir}/root.pem"
validation_client_name   "chef-validator"
validation_key           "#{cache_dir}/chef-validator.pem"
chef_server_url          "https://localhost:4443"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]
