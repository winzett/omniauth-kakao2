require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Kakao < OmniAuth::Strategies::OAuth2

      option :name, 'kakao'

      option :client_options, {
        :site => 'https://kauth.kakao.com',
        :authorize_path => 'https://kauth.kakao.com/oauth/authorize',
        :token_url => 'https://kauth.kakao.com/oauth/token',
      }

      uid { raw_info['id'].to_s }

      info do
        {
          'name' => raw_properties&.dig('nickname'),
          'profile' => raw_properties&.dig('profile_image'),
          'image' => raw_properties&.dig('thumbnail_image'),
          'kakao_account' => {
                                'profile' => raw_kakao_account&.dig('profile'),
                                'email' => raw_kakao_account&.dig('email'),
                                'age_range' => raw_kakao_account&.dig('age_range'),
                                'birthday' => raw_kakao_account&.dig('birthday'),
                                'gender' => raw_kakao_account&.dig('gender'),
                                'phone_number' => raw_kakao_account&.dig('phone_number'),
                              }
        }
      end
      
      extra do
        {'properties' => raw_properties}
      end

    private
      def raw_info
        @raw_info ||= access_token.get('https://kapi.kakao.com/v2/user/me', {}).parsed || {}
      end

      def raw_properties
        @raw_properties ||= raw_info.dig('properties')
      end

      def raw_kakao_account
        @raw_properties ||= raw_info.dig('kakao_account')
      end
      
    end
  end
end

OmniAuth.config.add_camelization 'kakao', 'Kakao'
