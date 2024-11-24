module WebServices
  class FactoryResponse
    def self.create_response(origin:, response:, type:)
      case type
      when 'success'
        PokemonResponse.new(origin:, response:)
      when'failed'
        PokemonFailedResponse.new(response:)
      end
    end
  end
end
