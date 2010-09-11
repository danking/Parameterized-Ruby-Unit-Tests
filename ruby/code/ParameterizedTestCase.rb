require 'test/unit'

class ParameterizedTestCase < Test::Unit::TestCase
  def self.suite
    method_names = public_instance_methods(true)
    target_method_names = method_names.find_all do |method_name|
      method_name =~ /^ptest./
    end

    puts "target_method_names: #{target_method_names.inspect}"

    parameterized_tests = collect_names_and_parameters(target_method_names)

    puts "parameterized_tests: #{parameterized_tests.inspect}"

    parameterized_tests.each do |test|
      define_sub_tests(test)
    end

    super # on with TestCase's magic!
  end

  # define_sub_tests : ParameterizedTest ->
  # defines the parameterized test's sub tests from the supplied parameters
  def self.define_sub_tests(test)
    test.parameters.each do |parameter|

      if parameter[0].to_s.empty?
        raise ArgumentError,
              "One of #{method_name}'s parameters name's string representation" +
              "is the empty string, this is not allowed."
      end

      if parameter.length - 1 != instance_method(test.name).arity
        raise ArgumentError,
              "#{method_name}'s #{parameter} parameter specifies " +
              "#{parameter.length -1} arguments but #{method_name} takes " +
              "#{instance_method(test.name).arity}"
      end

      define_method("test#{strip_ptest(test.name)}#{parameter[0]}".to_sym) do
        __send__(test.name, *(parameter[1..parameter.length]))
      end
    end
  end
  private_class_method :define_sub_tests

  # collect_names_and_parameters : [ArrayOf Symbol]
  #                             -> [ArrayOf ParameterizedTest]
  # collects the test method names and parameters into ParameterizedTest objects
  def self.collect_names_and_parameters(target_method_names)
    target_method_names.collect do |method_name|
      parameter_name = "@@parameter#{strip_ptest(method_name)}".to_sym

      puts "class_variables: #{class_variables}"

      if class_variable_defined?(parameter_name)
        ParameterizedTest.new(method_name, class_variable_get(parameter_name))
      else
        raise ArgumentError,
              "#{method_name} is a parameterized test but has no parameters " +
              "which would be named #{parameter_name}"
      end
    end
  end
  private_class_method :collect_names_and_parameters

  # strip_ptest : Symbol -> String
  # removes the 'ptest' prefix from the symbol and returns it as a string
  def self.strip_ptest(method_name)
    method_string = method_name.to_s
    method_string.slice(5..method_string.length)
  end
  private_class_method :strip_ptest
end

class ParameterizedTest
  attr_accessor :name, :parameters

  def initialize(name, parameters)
    @name = name
    @parameters = parameters
  end
end
