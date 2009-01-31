class Stuffy::VideoFile < Stuffy::Plugin
    plugin_name 'video file'
    default_commands
    property :location
    def initialize(_location)
        self.location = File.expand_path(_location)
    end
    def primary_key; location; end
    command 'watch', 'plays a Video file using config:video-player', '{video-file-id}' do |id|
        vf = Stuffy::Objects.find 'video file', id.to_i
        system Stuffy::Objects.config('video-player'), sf.location
    end
end
