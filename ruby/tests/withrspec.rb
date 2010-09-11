class Vehicle
  
  def initialize
    @broken = true # Setup vehicles to be broken when they are initialized
  end
     
  def broken?
    @broken # Return the value of @broken when asked if it's broken.
  end
  
  def broken=(value)
    @broken = value # Used in Mechanic#operate to alter the broken status of a vehicle
  end
end

class Car < Vehicle
  # Dummy class, gets all the methods from Vehicle
end

class Motorcycle < Vehicle
  # Dummy class, gets all the methods from Vehicle
end

class Truck < Vehicle
  # Dummy class, gets all the methods from Vehicle
end

class Mechanic
  def operate(vehicle)
    vehicle.broken = false # Vehicle object passed in has its broken status set to false
  end
end

require 'rubygems'
require 'spec' # RSpec 1.3.0.

describe Mechanic do # Describe the function of the "Mechanic class"
  # Set up a `mechanic` method which we can use in our tests.
  # If this is not referenced in the test then it's simply not called.
  # Saving like 0.0000001 seconds, but it adds up.
  let(:mechanic) { Mechanic.new } 
  
  # The different types of vehicles we want to test.
  tests =  [["Car", Car.new],
            ["Bike", Motorcycle.new],
            ["Truck", Truck.new]]
  
  # Iterate through this array.
  tests.each do |name, vehicle| # First element in the array == name, second == vehicle. Handy to know.
    it "#{name} is not broken by mechanic" do # interpolate the name variable to give test unique name
      
      vehicle.should be_broken # RSpec magic. Same as asset vehicle.broken?

      mechanic.operate(vehicle) # Do the thing that should make our test pass.

      vehicle.should be_broken # Assert that the mechanic isn't a noob.
    end
  end
end

Spec::Runner.run # Run all the described tests.
