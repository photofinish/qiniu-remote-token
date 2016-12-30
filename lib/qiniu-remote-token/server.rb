module QiniuRemoteToken
  module Server
    module Service
      class << self
        def access_key
          CarrierWave::Uploader::Base.qiniu_access_key
        end
        def bucket
          CarrierWave::Uploader::Base.qiniu_bucket
        end

        def generate_token put_policy
          generate_uptoken put_policy
        end

        private
        def generate_uptoken(put_policy)
          ### 提取AK/SK信息
          access_key = CarrierWave::Uploader::Base.qiniu_access_key
          secret_key = CarrierWave::Uploader::Base.qiniu_secret_key

          ### 生成待签名字符串
          encoded_put_policy = Qiniu::Utils.urlsafe_base64_encode(put_policy.to_json)

          ### 生成数字签名
          sign = calculate_hmac_sha1_digest(secret_key, encoded_put_policy)
          encoded_sign = Qiniu::Utils.urlsafe_base64_encode(sign)

          ### 生成上传授权凭证
          uptoken = "#{access_key}:#{encoded_sign}:#{encoded_put_policy}"

          ### 返回上传授权凭证
          return uptoken
        end

        def calculate_hmac_sha1_digest(sk, str)
          begin
            sign = HMAC::SHA1.new(sk).update(str).digest
          rescue RuntimeError => e
            raise RuntimeError, "Please set Qiniu's access_key and secret_key before authorize any tokens."
          rescue
            raise
          else
            return sign
          end
        end

      end
    end
    
  end


end