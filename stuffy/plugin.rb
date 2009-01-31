module Stuffy
    class Plugin
        ALL = []
        def self.new(*args)
            p = allocate
            p.instance_variable_set("@table", {})
            p.__send__(:initialize, *args)
            Stuffy::Objects.add plugin_name, p
            p
        end
        def initialize
        end
        attr_reader :id
        def self.inherited(subclass)
            Stuffy::Plugin::ALL << subclass
        end
        private
        def self.plugin_name _name=nil
            if _name
                @@name = _name
            else
                @@name
            end
        end
        def self.command _name, help, args="", &blk
            Stuffy::COMMANDS[plugin_name.gsub(' ', '-').downcase] ||= []
            Stuffy::COMMANDS[plugin_name.gsub(' ', '-').downcase] << [_name, help, args, blk]
        end
        def self.default_commands
            command "add", "adds a new #{plugin_name.capitalize} to the index", "{#{plugin_name.gsub(' ', '-')}-location}" do |object_location|
                new object_location
            end
            command "remove", "removes a #{plugin_name.capitalize} from the index", "{#{plugin_name.gsub(' ', '-')}-id}" do |_object_id|
                Stuffy::Objects.remove plugin_name, _object_id.to_i
            end
        end
        def self.property _name
            define_method(_name.to_s)        {    @table[_name.to_s]     }
            define_method(_name.to_s << '=') {|v| @table[_name.to_s] = v }
        end
    end
end
