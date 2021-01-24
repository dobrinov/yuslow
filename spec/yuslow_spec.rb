require 'spec_helper'

describe Yuslow do
  it 'is executed via block' do
    Yuslow.run(output: false) { Dummy.execute }
  end

  it 'is executed with explicit commands' do
    investigation = Yuslow.investigation output: false

    investigation.start
    Dummy.execute
    investigation.finish
  end

  it 'prints to $stdout' do
    expected =
      <<~OUTPUT
        Thread[1]:
          \e[32m#<Class:Dummy>#execute\e[0m elapsed \e[1;37m0\e[0m ms
            \e[32mClass#new\e[0m elapsed \e[1;37m0\e[0m ms
              \e[32mDummy#initialize\e[0m elapsed \e[1;37m0\e[0m ms
            \e[32mDummy#execute\e[0m elapsed \e[1;37m0\e[0m ms
              \e[32mDummy#foo\e[0m elapsed \e[1;37m0\e[0m ms
                \e[32mDummy#slow_operation_one\e[0m elapsed \e[1;37m0\e[0m ms
              \e[32mDummy#bar\e[0m elapsed \e[1;37m0\e[0m ms
                \e[32mDummy#slow_operation_two\e[0m elapsed \e[1;37m0\e[0m ms
                \e[32mDummy#slow_operation_three\e[0m elapsed \e[1;37m0\e[0m ms
      OUTPUT

    expect do
      Yuslow.run(output: :stdout) { Dummy.execute }
    end.to output(expected).to_stdout
  end
end
