default[:geminabox] 							= Mash.new
default[:geminabox][:version]					= '~> 0.6.0'
# sys configs
default[:geminabox][:www_user] 					= 'www-data'
default[:geminabox][:www_group] 				= 'www-group'
# RVM Configs
default[:geminabox][:rvm][:install] 			= true
default[:geminabox][:rvm][:default_ruby] 		= 'ruby-1.9.3-p484@lx-gem'
default[:geminabox][:rvm][:user] 				= default[:geminabox][:www_user]
# app configs
default[:geminabox][:config_directory] 			= '/etc/geminabox'
default[:geminabox][:base_directory] 			= '/var/www/geminabox'
default[:geminabox][:data_directory] 			= 'data' # This values is joined to base_directory
default[:geminabox][:build_legacy] 				= false
# auth configs
default[:geminabox][:auth_required] 			= false
# ssl configs
default[:geminabox][:ssl][:enabled] 			= false
# unicorn configs
default[:geminabox][:unicorn] 					= Mash.new
default[:geminabox][:unicorn][:install] 		= false
default[:geminabox][:unicorn][:version] 		= '> 0'
default[:geminabox][:unicorn][:cow_friendly] 	= true
default[:geminabox][:unicorn][:timeout] 		= 30
default[:geminabox][:unicorn][:workers] 		= 2
default[:geminabox][:unicorn][:process_user] 	= default[:geminabox][:www_user]
default[:geminabox][:unicorn][:process_group] 	= default[:geminabox][:www_group]
default[:geminabox][:unicorn][:maxmemory] 		= 50
default[:geminabox][:unicorn][:maxcpu] 			= 20
default[:geminabox][:unicorn][:exec] 			= '/usr/bin/unicorn'
default[:geminabox][:unicorn][:pid] 			= '/var/run/unicorn.pid'

# nginx configs
default[:geminabox][:nginx] 					= Mash.new
# bluepill configs
default[:geminabox][:bluepill] 					= Mash.new
