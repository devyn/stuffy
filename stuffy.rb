module Stuffy
    COMMANDS = {}
end
require 'stuffy/plugin'
require 'stuffy/objects'
Dir.glob("plugins/*.rb").each {|r| load r}
if __FILE__ == $0
    Stuffy::Objects.load_db
    Stuffy::COMMANDS[ARGV[0]].select{|c|c[0] == ARGV[1]}.first[3].call(*ARGV[2..-1])
    Stuffy::Objects.save_db
end
