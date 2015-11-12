# encoding: utf-8
module Sonar
  module Registration

    # Takes a Metasploit Product Key and attempts
    # to register a Sonar account with it.
    def register_metasploit(product_key)
      post_params = { product_key: product_key.dup }
      post_to_sonar('metasploit_verify', post_params)
    end
  end
end
