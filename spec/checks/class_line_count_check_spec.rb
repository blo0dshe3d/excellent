require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Simplabs::Excellent::Checks::ClassLineCountCheck do

  before do
    @excellent = Simplabs::Excellent::Runner.new(Simplabs::Excellent::Checks::ClassLineCountCheck.new({ :threshold => 3 }))
  end

  describe '#evaluate' do

    it 'should accept classes with less lines than the threshold' do
      content = <<-END
        class OneLineClass; end
      END
      @excellent.check_content(content)

      @excellent.errors.should be_empty
    end

    it 'should accept classes with the same number of lines as the threshold' do
      content = <<-END
        class ThreeLineClass
          @foo = 1
        end
      END
      @excellent.check_content(content)

      @excellent.errors.should be_empty
    end

    it 'should not count blank lines' do
      content = <<-END
        class ThreeLineClass

          @foo = 1

        end
      END
      @excellent.check_content(content)

      @excellent.errors.should be_empty
    end

    it 'should reject classes with more lines than the threshold' do
      content = <<-END
        class FourLineClass
          @foo = 1
          @bar = 2
        end
      END
      @excellent.check_content(content)
      errors = @excellent.errors

      errors.should_not be_empty
      errors[0].info.should        == { :class => 'FourLineClass', :count => 4 }
      errors[0].line_number.should == 1
      errors[0].message.should     == 'FourLineClass has 4 lines.'
    end

  end

end