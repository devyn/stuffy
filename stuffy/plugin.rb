module Stuffy
    class Plugin
        ALL = []
        def self.inherited(subclass)
            Stuffy::Plugin::ALL << subclass
            class << subclass
                attr_reader :name
                def new(*args)
                    p = allocate
                    p.instance_variable_set("@table", {})
                    p.__send__(:initialize, *args)
                    Stuffy::Objects.add plugin_name, p
                    p
                end
                def get_plugin_name; @name.dup; end
                private
                def plugin_name _name=nil
                    if _name
                        @name = _name
                    else
                        @name
                    end
                end
                def command _name, help, args="", &blk
                    Stuffy::COMMANDS[plugin_name.gsub(' ', '-').downcase] ||= []
                    Stuffy::COMMANDS[plugin_name.gsub(' ', '-').downcase] << [_name, help, args, blk]
                end
                def default_command_add
                    command "add", "adds a new #{plugin_name.capitalize} to the index", "{#{plugin_name.gsub(' ', '-')}-location}" do |object_location|
                        Stuffy::Output.action "adding the \\{type}#{plugin_name}\\{normal} \"#{object_location}\" to the index"
                        Stuffy::Output.message "has ID=\\{id}#{new(object_location).id}\\{normal}"
                    end
                end
                def default_command_remove
                    command "remove", "removes a #{plugin_name.capitalize} from the index", "{#{plugin_name.gsub(' ', '-')}-id}" do |_object_id|
                        Stuffy::Output.action "removing the \\{type}#{plugin_name}\\{normal} #\\{id}#{_object_id}\\{normal}"
                        Stuffy::Objects.remove plugin_name, _object_id.to_i
                    end
                end
                def default_command_list
                    command "list", "list of all #{plugin_name.capitalize} objects" do
                        Stuffy::Output.action "list of all \\{type}#{plugin_name}\\{normal} objects"
                        Stuffy::Objects.all(plugin_name).each do |ob|
                            Stuffy::Output.message "\\{id}(#{ob.id})\\{normal} #{ob.primary_key}"
                        end
                    end
                end
                def default_commands
                    default_command_add
                    default_command_remove
                    default_command_list
                end
            end
            def subclass.property _name
                define_method(_name.to_s)        {    @table[_name.to_s]     }
                define_method(_name.to_s << '=') {|v| @table[_name.to_s] = v }
            end
            subclass.class_eval do
                attr_reader :id
                def initialize; end
                def primary_key; end
            end
        end
    end
end
