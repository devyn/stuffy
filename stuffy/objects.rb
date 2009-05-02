require 'yaml'
module Stuffy
    module Objects; extend self
        def load_db(file=ENV['STUFFY_DB']||"stuffy.db.yml")
            @db_loc = file
            @db = YAML.load_file(file)
        rescue Exception
            @db = {
                    'objects_count' => 0,
                    'objects'       => {},
                    'config'        => {'colors' => {}}
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
            find(type, id).delete
        end
        def find(type, id)
            @db['objects'][type].find{|o|o.id == id}
        end
        def search(pkey)
            ob_match = []
            @db['objects'].each do |ot,vs|
                ob_match += vs.select{|o|o.primary_key.to_s =~ /#{Regexp.escape(pkey)}/i}
            end
            return ob_match
        end
        def all(type)
            @db['objects'][type]
        end
        def config(key)
            @db['config'][key]
        end
    end
end
