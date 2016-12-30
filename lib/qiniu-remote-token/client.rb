require 'qiniu-remote-token/base'

module QiniuRemoteToken
  module Client
    extend ActiveSupport::Concern
    included do
      Qiniu::HTTP.define_singleton_method :generate_query_string do |params|
        if params.is_a?(Hash) and params[:ak].start_with?('http')
          params = Service.show
        end

        if params.is_a?(Hash)
          total_param = params.map { |key, value| %Q(#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s).gsub('+', '%20')}) }
          return total_param.join("&")
        end
        return params
      end
      Qiniu::Auth.define_singleton_method :generate_uptoken do |put_policy|
        tocken = Service.create(put_policy)
      end
    end

    class Service < Base

      class << self
        def instance
          @instance ||= self.new
        end
        def create(put_policy)
          data = self.instance.send :post, CarrierWave::Uploader::Base.qiniu_secret_key, put_policy
          data[:token]
        end
        def show
          data = self.instance.send :get, CarrierWave::Uploader::Base.qiniu_access_key
          data
        end
      end

      private
      def initialize ;end
      def post(url, data = nil)
        get url do
          req = Net::HTTP::Post.new(url, 'Content-Type' => 'application/json')
          req.body = data.to_json
          req
        end
      end
      def get(url)
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        if block_given?
          req = yield
        else
          req = Net::HTTP::Get.new(uri, 'Content-Type' => 'application/json')
        end
        response = http.request(req)
        case response.code
          when '200'
            return JSON.parse(response.body).with_indifferent_access
          else
            raise ResponseError, "error with #{response.code} "
        end
      end

    end
  end
end
