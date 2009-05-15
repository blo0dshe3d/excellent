require 'simplabs/excellent/checks/base'

module Simplabs

  module Excellent

    module Checks

      class AbcMetricMethodCheck < Base

        DEFAULT_THRESHOLD = 10

        def initialize(options = {})
          super()
          @threshold = options[:threshold] || DEFAULT_THRESHOLD
        end

        def interesting_nodes
          [:defn, :defs]
        end

        def evaluate(context)
          add_error('{{method}} has abc score of {{score}}.', { :method => context.full_name, :score => context.abc_score }) unless context.abc_score <= @threshold
        end

      end

    end

  end

end