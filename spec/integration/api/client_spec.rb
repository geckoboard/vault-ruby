require "spec_helper"

module Vault
  describe Client do

    def free_address
      server = TCPServer.new("localhost", 0)
      address = [server.addr[2], server.addr[1]]
      server.close
      address
    end

    describe "#request", :focus do
      specify "raises HTTPConnectionError if it takes too long to read packets from the connection" do
        TCPServer.open('localhost', 0) do |server|
          Thread.new do
            client = server.accept
            sleep 1
            client.close
          end

          address = "http://%s:%s" % [server.addr[2], server.addr[1]]

          client = described_class.new(address: address, token: "foo", connection_read_timeout: 0.01)

          expect { client.request(:get, "/", {}, {}) }.to raise_error(HTTPConnectionError)
        end
      end

      specify "raises HTTPConnectionError if ssl negotiation takes too long to start" do
        TCPServer.open('localhost', 0) do |server|
          Thread.new do
            client = server.accept
            sleep 5
            client.close
          end

          address = "https://%s:%s" % [server.addr[2], server.addr[1]]

          # This test intentionally uses connection_open_timeout, as that's the timeout
          # Net::HTTP uses when waiting for OpenSSL.
          client = described_class.new(address: address, token: "foo", connection_open_timeout: 0.01)

          expect { client.request(:get, "/", {}, {}) }.to raise_error(HTTPConnectionError)
        end
      end

      specify "raises HTTPConnectionError if the port on the remote server is not open" do
        address = "http://%s:%s" % free_address

        client = described_class.new(address: address, token: "foo")

        expect { client.request(:get, "/", {}, {}) }.to raise_error(HTTPConnectionError)
      end
    end
  end
end
