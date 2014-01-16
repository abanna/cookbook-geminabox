# Ensure our directories exist
directory node[:geminabox][:config_directory] do
  action :create
  recursive true
  mode '0755'
end

directory File.join(node[:geminabox][:base_directory], node[:geminabox][:data_directory]) do
  action :create
  recursive true
  mode '0755'
  owner node[:geminabox][:www_user]
  group node[:geminabox][:www_group]
end

# Setup the frontend
if(node[:geminabox][:nginx] || :this_is_all_we_support_now)
  include_recipe 'geminabox::nginx'
end

include_recipe 'rvm'

puts node[:geminabox][:www_user]

if node[:geminabox][:rvm]
  rvm_gem 'geminabox' do
    ruby_string node[:geminabox][:rvm][:default_ruby]
    user        node[:geminabox][:rvm][:user] 
    version     node[:geminabox][:version] || '~> 0.6.0'
    action      :install
  end
else
  # Install the gem
  gem_package('geminabox') do
    action :install
    version node[:geminabox][:version] || '~> 0.6.0'
  end
end

service 'geminabox' do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

# Load up the monitoring
if(node[:geminabox][:bluepill])
  include_recipe 'geminabox::bluepill'
end

# Add monit here.
if(node[:geminabox][:monit])
# add monit config here.
end

# Configure up server instance
if(node[:geminabox][:unicorn] || :this_is_all_we_support)
  include_recipe 'geminabox::unicorn'
end

template File.join(node[:geminabox][:base_directory], 'config.ru') do
  source 'config.ru.erb'
  variables(
    :geminabox_data_directory => File.join(node[:geminabox][:base_directory], node[:geminabox][:data_directory]),
    :geminabox_build_legacy => node[:geminabox][:build_legacy]
  )
  mode '0644'
  notifies :restart, 'service[geminabox]'
end
