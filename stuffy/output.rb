module Stuffy
    module Output; extend self
        def message(s)
            puts template_to_ansi("\\{message-indicator}>>>\\{normal} #{s}")
        end
        def action(s)
            puts template_to_ansi("\\{action-indicator}:::\\{normal} #{s}")
        end
        def help(s)
            puts template_to_ansi("\\{help-indicator}???\\{normal} #{s}")
        end
        private
        def template_to_ansi(s, normal="\e[0m")
            colors = Stuffy::Objects.config 'colors'
            s.gsub(/\\\{([A-Za-z0-9._-]+)\}/) { $1 == 'normal' ? normal : colors[$1] }
        end
    end
end
