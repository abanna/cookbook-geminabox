if(node[:geminabox][:unicorn][:install])
  if node[:geminabox][:rvm]
    rvm_gem 'unicorn' do
      ruby_string node[:geminabox][:rvm][:default_ruby]
      user        node[:geminabox][:rvm][:user] 
      action      :install
    end
  else
    gem_package 'unicorn' do
      action :install    
      version node[:geminabox][:unicorn][:version] || '> 0'
    end
  end
end

if node[:platform] == 'centos' || node[:platform] == 'amazon'
  template '/etc/init.d/unicorn' do
    source 'unicorn.init.erb'    
    owner "root"
    group "root"
    mode 0755
    variables(
      :ruby_string => node[:geminabox][:rvm][:default_ruby],
      :user => node[:geminabox][:user]
    )

    action :create
  end

  service 'unicorn' do
    provider Chef::Provider::Service::Init::Redhat
    init_command '/etc/init.d/unicorn' 

    supports :start => true, :stop => true
    action [:enable, :start]
  end

end

node.default[:unicorn][:preload_app] = true
node.default[:unicorn][:worker_processes] = [node[:cpu][:total].to_i * 4, 8].min
node.default[:unicorn][:preload_app] = false
node.default[:unicorn][:before_fork] = 'sleep 1'
node.default[:unicorn][:port] = 'unix:/' + File.join(node[:geminabox][:base_directory], 'unicorn.socket')
node.set[:unicorn][:options] = { :tcp_nodelay => true, :backlog => 100 }

unicorn_config File.join(node[:geminabox][:config_directory], 'geminabox.unicorn.app') do
  listen node[:unicorn][:port] => node[:unicorn][:options]
  pid node[:unicorn][:pid] || '/var/run/unicorn.pid'
  worker_processes node[:geminabox][:unicorn][:workers] || 2
  worker_timeout node[:geminabox][:unicorn][:timeout] || 30
  working_directory node[:geminabox][:base_directory]
  preload_app true
  owner node[:geminabox][:www_user] || 'www-data'
  group node[:geminabox][:www_user] || 'www-data'
  mode '0644'
  notifies :restart, 'service[geminabox]'
end

