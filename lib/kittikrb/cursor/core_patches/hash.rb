module KittikRb
  module Cursor
    module CorePatches
      module HashPatch
        refine Hash do
          # From ActiveSupport v5.0.0.beta3
          def slice(*keys)
            if respond_to?(:convert_key, true)
              keys.map! { |key| convert_key(key) }
            end

            keys.each_with_object(self.class.new) do |k, hash|
              hash[k] = self[k] if has_key?(k)
            end
          end
        end
      end
    end
  end
end
