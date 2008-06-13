$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

unless defined?(ActiveRecord)
  begin
    require 'active_record'  
  rescue LoadError
    require 'rubygems'
    require_gem 'activerecord'
  end
end

module DrNicMagicModels
    Logger = RAILS_DEFAULT_LOGGER rescue Logger.new(STDERR)
    
    mattr_accessor :module_scopes_only
    mattr_accessor :scopes
    mattr_accessor :in_use
    
    @@module_scopes_only = false
    @@in_use = true
    @@scopes = []
    
  # utility methods for dealing with exclusive scoping; the scopes attribute is set in Module.magic_module
  class << self
    def go_exclusive
      self.module_scopes_only = true
      Object.clear_magic_schema
    end
    
    def exclusive_scopes?
      module_scopes_only
    end
    
    # These are largely useful in testing -- to make sure that things are really undefined!
    def no_more_magic!
      self.in_use = false
    end
    
    def magic!
      self.in_use = true
    end
  end
end

require 'dr_nic_magic_models/magic_model'
require 'dr_nic_magic_models/schema'
require 'dr_nic_magic_models/validations'
require 'dr_nic_magic_models/inflector'
require 'base'
require 'module'
require 'rails' rescue nil
require 'connection_adapters/abstract_adapter'
require 'connection_adapters/mysql_adapter'
require 'connection_adapters/postgresql_adapter'

# load the schema
# TODO - add this to README - DrNicMagicModels::Schema.load_schema(true)

class ActiveRecord::Base
  include DrNicMagicModels::MagicModel
  extend DrNicMagicModels::Validations
end