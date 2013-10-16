# L2metable

Mixin for l2met style logging. (we use it at heroku)

## Installation

Add this line to your application's Gemfile:

    gem 'l2metable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install l2metable

## Usage

```ruby
require 'l2metable'

class ThingToBeLogged
    include L2Metable
    
    def initialize
        #some import that peice of state
        @value = "Hello"
    end
    
    def lotsowork
       #sample data (use this for random samples of things... 
       # if you want to push them to librato it needs to be numeric
       #"ThingToBeLogged.value=Hello sample#ThingToBeLogged.test=test"
       sample "test", "test"
       
       #count things (use this when you want to count how many times something happend) 
       #"ThingToBeLogged.value=Hello count#ThingToBeLogged.counter=1"
       sample "counter", 1 # the 1 is optional
       
       #measure things this is for things where you want to be able to get lots of metric
       #"ThingToBeLogged.value=Hello measure#ThingToBeLogged.howlong=1s"
       measure "howlong", "1s" 
       
       #monitor how long things take and when they start and finish
       #"ThingToBeLogged.value=Hello ThingToBeLogged.lotsowork.start=1"
       #"ThingToBeLogged.value=Hello ThingToBeLogged.lotsowork.end=1 ThingsToBeLogged.lotsowork.elapsed=5s"
       monitor "lotsowork" do
         sleep 5
         #scope will also apply when you call l2metable functions inside a monitor
         #"ThingToBeLogged.value=Hello sample#ThingToBeLogged.lotsowork.thing=1"
         sample "thing" 1
       end
    end
    
    #This will be called on every time a line is logged
    #it tells l2metable what items you want on every line
    def log_base_hash()
      { :value => @value }
    end
    
    #this will be called every time a line is logged
    #it tells loggable how you want your name made
    def log_component(sub)
       "ThingToBeLogged.#{sub}"
    end

end
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
