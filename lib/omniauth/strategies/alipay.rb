# lots of stuff taken from https://github.com/intridea/omniauth/blob/0-3-stable/oa-oauth/lib/omniauth/strategies/oauth2/taobao.rb
require 'omniauth-oauth2'
module OmniAuth
  module Strategies
    class Taobao < OmniAuth::Strategies::OAuth2
      USER_METHODS = {
        :default => 'alipay.user.get'
      }

      USER_RESPONSE = {
        :default => 'alipay_user_get_response'
      }

      option :client_options, {
        :authorize_url => 'https://openauth.alipay.com/oauth2/authorize',
        :token_url => 'https://openauth.alipay.com/oauth2/token',
      }
      def request_phase
        options[:state] ||= '1'
        super
      end

      uid { raw_info['alipay_user_id'] }

      info do
        {
          'uid' => raw_info['alipay_user_id'],
          'nickname' => raw_info['real_name'],
          'email' => raw_info['logon_id'],
          'sex' => raw_info['sex']
        }
      end

      def raw_info
        url = 'https://openapi.alipay.com/gateway.do'

        user_type = options.client_options.user_type || :default
        query_param = {
          :app_key => options.client_id,

          # TODO to be moved in options
          # TODO add more default fields (http://my.open.taobao.com/apidoc/index.htm#categoryId:1-dataStructId:3)
          :fields => 'alipay_user_id,real_name,logon_id,sex,user_status,user_type,created,last_visit,birthday,type,status',
          :format => 'json',
          :method => USER_METHODS[user_type],
          :session => @access_token.token,
          :sign_method => 'md5',
          :timestamp   => Time.now.strftime('%Y-%m-%d %H:%M:%S'),
          :v => '2.0'
        }
        query_param = generate_sign(query_param)
        res = Net::HTTP.post_form(URI.parse(url), query_param)
        response = MultiJson.decode(res.body)
        raise OmniAuth::Error.new(response['error_response']) if response.has_key?('error_response')
        @raw_info ||= response[USER_RESPONSE[user_type]]['alipay_user_detail']
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end
      
      def generate_sign(params)
        # params.sort.collect { |k, v| "#{k}#{v}" }
        str = options.client_secret + params.sort {|a,b| "#{a[0]}"<=>"#{b[0]}"}.flatten.join + options.client_secret
        params['sign'] = Digest::MD5.hexdigest(str).upcase!
        params
      end
    end
  end
end