# require 'Win32API'
require 'win32ole'

module AutoIt
  # Class module to execute control commands on AutoIt DLL. Its possible
  # to run native commands and some methods for object
  class Control
    attr_reader :win

    def initialize
      @win = WIN32OLE.new('AutoItX3.Control')
    end

    def command(cmd, args = {})
      execute { win.send(cmd, *args) }
    end

    def win_close(title)
      execute { win.WinClose title }
    end

    def open_app(app)
      execute { win.run app }
    end

    def click_on(title, id, text = nil)
      execute do
        win.WinWaitActive(title, nil, 30)
        win.ControlClick(title, text, id)
      end
    end

    def get_text(title)
      win.WinGetText(title)
    end

    def text?(title, text, get_int = false)
      found = get_text title
      found = text.to_i.to_s if get_int
      found == text
    end

    private

    def execute
      yield > 0
    end
  end
end