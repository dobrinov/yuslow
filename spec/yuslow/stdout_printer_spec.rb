require 'spec_helper'

module Yuslow
  describe StdoutPrinter do
    it 'prints to $stdout' do
      child_operation =
        Operation.new object: Dummy,
                      method: :foo,
                      started_at: Time.new(2021, 01, 24, 0, 0, 1),
                      completed_at: Time.new(2021, 01, 24, 0, 0, 2)

      thread_one =
        Operation.new object: Dummy,
                      method: :execute,
                      started_at: Time.new(2021, 01, 24, 0, 0, 0),
                      completed_at: Time.new(2021, 01, 24, 0, 0, 2),
                      children: [child_operation]

      thread_two =
        Operation.new object: Dummy,
                      method: :execute,
                      started_at: Time.new(2021, 01, 24, 0, 0, 0),
                      completed_at: Time.new(2021, 01, 24, 0, 0, 1)

      expected =
        <<~OUTPUT
          Thread[1]:
            Dummy#execute elapsed 2000 ms
              Dummy#foo elapsed 1000 ms

          Thread[2]:
            Dummy#execute elapsed 1000 ms
        OUTPUT

      expect do
        StdoutPrinter.execute([thread_one, thread_two], false)
      end.to output(expected).to_stdout
    end
  end
end
