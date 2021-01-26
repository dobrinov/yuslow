# Yuslow
Yuslow `[waɪ ju sləʊ]` is a lightweight profiler for Ruby designed to debug slow parts of your system.

## Install

```
gem install yuslow
```

## Usage
Require the gem in the file which you would like to investigate.

```ruby
require 'yuslow'
```

then add

```ruby
Yuslow.run do
  a_very_slow_method
end
```

or

```ruby
investigation = Yuslow.investigation

investigation.start
a_very_slow_method
investigation.finish
```

to your code. Execute the code and you will see output in $stdout with the following tree structure. It will help you understand which branch and method of your code has poor performance.

```
Thread[1]:
  Object#very_slow elapsed 1000 ms
    Object#not_my_fault elapsed 1000 ms
      Object#not_me elapsed 0 ms
      Object#root_cause elapsed 1000 ms
        Kernel#sleep elapsed 1000 ms
```

## Parameters
| Parameter     | Options           | Default   | Description                                         |
|---------------|-------------------|-----------|-----------------------------------------------------|
| **output**    | `false` `:stdout` | `:stdout` | Defines how the profiling results will be presented |
| **max_level** | `number` `nil`   | `nil`     | Specifies maximum profiling depth                   |
| **debug**     | `true` `false`    | `false`   | Prints debug information while profiling            |
