class Stuffy::SoundFile < Stuffy::Plugin
    plugin_name 'sound file'
    default_commands
    property :location
    def initialize(_location)
        self.location = File.expand_path(_location)
    end
    def primary_key; location; end
    command 'play', 'plays a Sound file using config:sound-player', '{sound-file-id}' do |id|
        sf = Stuffy::Objects.find 'sound file', id.to_i
        system Stuffy::Objects.config('sound-player'), sf.location
    end
end
