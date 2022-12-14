# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Performance::BlockGivenWithExplicitBlock, :config do
  it 'registers an offense and corrects when using `block_given?` in an instance method with block arg' do
    expect_offense(<<~RUBY)
      def method(x, &block)
        do_something if block_given?
                        ^^^^^^^^^^^^ Check block argument explicitly instead of using `block_given?`.
      end
    RUBY

    expect_correction(<<~RUBY)
      def method(x, &block)
        do_something if block
      end
    RUBY
  end

  it 'registers an offense and corrects when using `block_given?` in a class method with block arg' do
    expect_offense(<<~RUBY)
      def self.method(x, &block)
        do_something if block_given?
                        ^^^^^^^^^^^^ Check block argument explicitly instead of using `block_given?`.
      end
    RUBY

    expect_correction(<<~RUBY)
      def self.method(x, &block)
        do_something if block
      end
    RUBY
  end

  it 'registers an offense and corrects when using `block_given?` in a method with non standard block arg name' do
    expect_offense(<<~RUBY)
      def method(x, &myblock)
        do_something if block_given?
                        ^^^^^^^^^^^^ Check block argument explicitly instead of using `block_given?`.
      end
    RUBY

    expect_correction(<<~RUBY)
      def method(x, &myblock)
        do_something if myblock
      end
    RUBY
  end

  it 'does not register an offense when using `block_given?` in a method without block arg' do
    expect_no_offenses(<<~RUBY)
      def method(x)
        do_something if block_given?
      end
    RUBY
  end

  it 'does not register an offense when block arg is reassigned' do
    expect_no_offenses(<<~RUBY)
      def method(a, &block)
        block ||= -> {}
        do_something if block_given?
      end
    RUBY
  end

  it 'does not register an offense when `block_given?` is used outside of a method' do
    expect_no_offenses(<<~RUBY)
      do_something if block_given?
    RUBY
  end

  context 'when Ruby >= 3.1', :ruby31 do
    it 'does not register an offense when using anonymous block argument' do
      expect_no_offenses(<<~RUBY)
        def method(x, &)
          raise ArgumentError, "block required" unless block_given?
          do_something(&)
        end
      RUBY
    end
  end
end
