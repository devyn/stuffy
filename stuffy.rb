#!/usr/bin/env ruby
module Stuffy
    VERSION = "alpha"
    COMMANDS = {}
end
$: << File.dirname(File.expand_path(__FILE__))
require 'stuffy/plugin'
require 'stuffy/objects'
require 'stuffy/output'
Dir.glob(File.join(File.dirname(File.expand_path(__FILE__)), "plugins/*.rb")).each {|r| load r}
if __FILE__ == $0
    case
    when ARGV[0] == 'help', ARGV.empty?
        Stuffy::Objects.load_db
        Stuffy::Output.action "\\{command}stuffy\\{normal} version \\{version}#{Stuffy::VERSION}\\{normal} help"
        Stuffy::Output.message "\t[[ a \\{type}thing\\{normal} to manage every \\{type}thing\\{normal} ]]"
        Stuffy::COMMANDS.each do |cg, cs|
            Stuffy::Output.help "\\{type}#{cg}\\{normal}"
            cs.each do |c|
                Stuffy::Output.help "\t\\{command}#{c[0]}\\{normal}#{" \\{command-parameters}#{c[2]}\\{normal}" unless c[2].empty?} \\{command-desc}# #{c[1]}\\{normal}"
            end
        end
    when ARGV[0] == 'search'
        Stuffy::Objects.load_db
        Stuffy::Objects.search(ARGV[1..-1].join(' ')).each do |ob|
            Stuffy::Output.message "\\{type}#{ob.class.get_plugin_name}\\{normal} \\{id}(#{ob.id})\\{normal} #{ob.primary_key}"
        end
    else
        Stuffy::Objects.load_db
        Stuffy::COMMANDS[ARGV[0]].select{|c|c[0] == ARGV[1]}.first[3].call(*ARGV[2..-1])
        Stuffy::Objects.save_db
    end
end
