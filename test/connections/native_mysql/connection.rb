print "Using native MySQL\n"
require 'logger'

ActiveRecord::Base.logger = Logger.new("debug.log")

db1 = "dr_nic_magic_models_unittest"

ActiveRecord::Base.establish_connection(
  :adapter  => "mysql",
  :username => "root",
  :password => "root",
  :encoding => "utf8",
  :socket   => "/tmp/mysql.sock",
  :database => db1
)
