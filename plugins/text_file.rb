class Stuffy::TextFile < Stuffy::Plugin
    plugin_name 'text file'
    default_commands
    property :location
    def initialize _location
        self.location = File.expand_path(_location)
    end
    def primary_key; location; end
    command 'read', 'reads a Text file', '{text-file-id}' do |id|
        tf = Stuffy::Objects.find 'text file', id.to_i
        File.open(tf.location) {|f| putc f.getc until f.eof? }
    end
end
