module Vault
  module Defaults
    # The default vault address.
    # @return [String]
    VAULT_ADDRESS = "https://127.0.0.1:8200".freeze

    class << self
      # The list of calculated options for this configurable.
      # @return [Hash]
      def options
        Hash[*Configurable.keys.map { |key| [key, public_send(key)] }.flatten]
      end

      # The address to communicate with Vault.
      # @return [String]
      def address
        ENV["VAULT_ADDR"] || VAULT_ADDRESS
      end

      # The vault token to use for authentiation.
      # @return [String, nil]
      def token
        ENV["VAULT_TOKEN"]
      end

      # Number of seconds to wait for the connection to open.
      # Any number may be used, including Floats for fractional seconds.
      # @return [Float]
      def connection_open_timeout
        if ENV['VAULT_CONNECTION_OPEN_TIMEOUT'].nil?
          3.0
        else
          ENV['VAULT_CONNECTION_OPEN_TIMEOUT'].to_f
        end
      end

      # Number of seconds to wait for a single block to be read.
      # Note that this is a per-block timeout, and the timeout is reset each time a block is read.
      # Any number may be used, including Floats for fractional seconds.
      # @return [Float]
      def connection_read_timeout
        if ENV['VAULT_CONNECTION_READ_TIMEOUT'].nil?
          5.0
        else
          ENV['VAULT_CONNECTION_READ_TIMEOUT'].to_f
        end
      end

      # The HTTP Proxy server address as a string
      # @return [String, nil]
      def proxy_address
        ENV["VAULT_PROXY_ADDRESS"]
      end

      # The HTTP Proxy server username as a string
      # @return [String, nil]
      def proxy_username
        ENV["VAULT_PROXY_USERNAME"]
      end

      # The HTTP Proxy user password as a string
      # @return [String, nil]
      def proxy_password
        ENV["VAULT_PROXY_PASSWORD"]
      end

      # The HTTP Proxy server port as a string
      # @return [String, nil]
      def proxy_port
        ENV["VAULT_PROXY_PORT"]
      end

      # The path to a pem on disk to use with custom SSL verification
      # @return [String, nil]
      def ssl_pem_file
        ENV["VAULT_SSL_CERT"]
      end

      # The path to the CA cert on disk to use for certificate verification
      # @return [String, nil]
      def ssl_ca_cert
        ENV["VAULT_CACERT"]
      end

      # The path to the directory on disk holding CA certs to use
      # for certificate verification
      # @return [String, nil]
      def ssl_ca_path
        ENV["VAULT_CAPATH"]
      end

      # Verify SSL requests (default: true)
      #
      # @return [true, false]
      def ssl_verify
        if ENV["VAULT_SSL_VERIFY"].nil?
          true
        else
          %w[t y].include?(ENV["VAULT_SSL_VERIFY"].downcase[0])
        end
      end

      # Number of seconds to wait for the initial SSL handshake to complete.
      # Any number may be used, including Floats for fractional seconds.
      # @return [Float, nil]
      def ssl_timeout
        if ENV["VAULT_SSL_TIMEOUT"].nil?
          nil
        else
          ENV["VAULT_SSL_TIMEOUT"].to_f
        end
      end
    end
  end
end
