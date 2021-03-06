require 'test_helper'
require 'byebug'

class ControlTest < Minitest::Test
  i_suck_and_my_tests_are_order_dependent!

  include AutoIt

  def setup
    @control = Control.new
  end

  def test_control_is_contol
    assert_equal @control.class, Control
  end

  def test_open_app
    assert @control.open_app('calc')
    @control.win_close 'Calculator'
  end
  
  def test_not_open_app
    refute @control.open_app('foo')
    error = assert_raises(RuntimeError) { @control.open_app nil }
    assert_equal error.message, "Parameter: '' is invalid!"
  end

  def test_sum
    @control.click_on('Calculator', '[ID:135]', '5')
    @control.click_on('Calculator', '[ID:93]', '+')
    @control.click_on('Calculator', '[ID:135]', '5')
    @control.click_on('Calculator', '[ID:121]', '=')
    assert @control.has_int?('Calculator', 10)
    @control.win_close 'Calculator'
  end

  def test_command
    args = ['Calculator', '8', '[ID:138]']
    @control.command('run', ['calc'])
    @control.command('WinWaitActive', ['Calculator', nil, 30])
    @control.command('ControlClick', args)
    assert @control.has_int?('Calculator', 8)
    @control.win_close 'Calculator'
    error = assert_raises(RuntimeError) {  @control.command('run', nil) }
    error = assert_raises(RuntimeError) {  @control.command('run') }
  end

  def test_win_activate
    refute @control.window_exists?('Calculator')
    assert @control.open_app 'notepad'
    assert @control.open_app 'calc'
    assert @control.window_activate 'Notepad'
    assert @control.window_activate 'Calculator'
    assert @control.window_active?('Calculator')
    @control.win_close 'Calculator'
    @control.win_close 'Notepad'
  end
end
