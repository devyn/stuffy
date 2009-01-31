require 'yaml'
module Stuffy
    module Objects; extend self
        def load_db(file=ENV['STUFFY_DB']||"stuffy.db.yml")
            @db_loc = file
            @db = YAML.load_file(file)
        rescue Exception
            @db = {
                    'objects_count' => 0,
                    'objects'       => {}
                  }
        end
        def save_db
            File.open(@db_loc, 'w') {|f| f.write YAML.dump(@db) }
        end
        def add(type, ob)
            @db['objects'][type] ||= []
            ob.instance_variable_set "@id", @db['objects_count'] += 1
            @db['objects'][type]  << ob
        end
        def remove(type, id)
            @db['objects'][type].reject!{|o|o.id == id}
        end
        def find(type, id)
            @db['objects'][type].select{|o|o.id == id}.first
        end
        def all(type)
            @db['objects'][type]
        end
    end
end
