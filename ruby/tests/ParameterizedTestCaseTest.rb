$LOAD_PATH << '../code'

require 'ParameterizedTestCase.rb'


class ParamterizedTestCaseTest < ParameterizedTestCase
  @@parameter_parameterized = [['six', 6],
                               ['nine', 9],
                               ['eighty-one', 81]]

  def ptest_parameterized(num)
    assert num % 3 == 0
  end

  def test_normaltest
    assert 42 == 42
  end

  def test_another_normaltest
    assert_raise(ZeroDivisionError) { 1/0 }
  end

end
