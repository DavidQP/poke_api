module Api
  module V1
    class PokemonsController < ApplicationController
      def pokemon
        if params[:pokemon_name].present?
          response = get_pokemon(pokemon_name: params[:pokemon_name])
          render json: response.pokemon_body, status: response.status
        else
          render json: { error: 'Invalid Parameters' }
        end
      end

      private

      def get_pokemon(pokemon_name:)
        ::V1::GetPokemonService.new(pokemon_name:).call
      end
    end
  end
end
