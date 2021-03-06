require 'spec_helper'

describe Simplabs::Excellent::Checks::ClassNameCheck do

  before(:each) do
    @excellent = Simplabs::Excellent::Runner.new([:ClassNameCheck => {}])
  end

  describe '#evaluate' do

    it 'should accept camel case class names starting in capitals' do
      code = <<-END
        class GoodClassName; end
      END
      @excellent.check_code(code)

      @excellent.warnings.should be_empty
    end

    it 'should be able to parse scoped class names' do
      code = <<-END
        class Outer::Inner::GoodClassName
          def method
          end
        end
      END
      @excellent.check_code(code)
s
      @excellent.warnings.should be_empty
    end

    it 'should reject class names with underscores' do
      code = <<-END
        class Bad_ClassName
        end
      END
      @excellent.check_code(code)
      warnings = @excellent.warnings

      warnings.should_not be_empty
      warnings[0].info.should        == { :class => 'Bad_ClassName' }
      warnings[0].line_number.should == 1
      warnings[0].message.should     == 'Bad class name Bad_ClassName.'
    end

  end

end
