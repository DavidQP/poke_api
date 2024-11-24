class PokemonProxy
  EXPIRATION = 24.hours.freeze

  attr_reader :client, :cache

  def initialize(client)
    @client = client
    @cache = Rails.cache
  end

  def get_pokemon(pokemon_name:)
    return WebServices::FactoryResponse.create_response(origin: 'on_cache', response: cache.read("pokemon_cached/#{pokemon_name}"), type: 'success') if cache.exist?("pokemon_cached/#{pokemon_name}")

    response = client.get_pokemon(pokemon_name:)
    if response.status == 200
      response.body['consulted_at'] = consulted_at
      cache.write("pokemon_cached/#{pokemon_name}", response, expires_in: EXPIRATION)
      WebServices::FactoryResponse.create_response(origin: 'client_call',  response:, type: 'success')
    else
      WebServices::FactoryResponse.create_response(origin: 'client_call',  response:, type: 'failed')
    end
  end

  private

  def consulted_at
    Time.now.utc.strftime('%FT%T')
  end
end
