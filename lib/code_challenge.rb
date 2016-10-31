#!/usr/bin/env ruby

require 'openssl'
require 'base64'
include OpenSSL

load 'constants.rb'

class CodeChallenge
  
  def initialize()
    puts "Initialized"
   
    @message = ARGV[0]
    puts "--- Message ---" 
    puts @message
    puts "--- Public Key File ---"
    puts PUBLIC_KEY
    puts "--- Private Key File ---"
    puts PRIVATE_KEY
    puts "--- DIGEST File ---"
    puts DIGEST
    puts "--- Signature File ---"
    puts SIGNATURE
  end

  # Generates public, private, digest, and signature
  def self.generate_keys(message)

    # create private and public key
    key = PKey::RSA.new(2048)
    privkey = key.to_pem
    public_key = key.public_key
    pubkey = public_key.to_pem
    
    # create sha256 digest of message
    digest = OpenSSL::Digest::SHA256.new
    
    # create signature by using the privaeg key to encrypt the digest
    signature = key.sign(digest, message) #privkey.dsa_sign_asn1 digest
    create_keys(pubkey, privkey, digest, signature)
  end

  # Creates physical key files
  def self.create_keys(pubkey, privkey, digest, signature)
    File.open(PUBLIC_KEY, 'w') { |f| f.write(pubkey) }
    File.open(PRIVATE_KEY, 'w') { |f| f.write(privkey) }
    File.open(DIGEST, 'w') { |f| f.write(digest) }
    File.open(SIGNATURE, 'w') { |f| f.write(signature) }
  end

  # Checks if key files exist
  def self.keys_exist
    return File.exist?(PRIVATE_KEY) && File.exist?(PUBLIC_KEY) && File.exist?(SIGNATURE)
  end

  # verifier
  def self.verify(public_key, digest, signature, message)
    return public_key.verify(digest, signature, message)
  end

  # Outputs JSON data
  def self.output_data(message)
    #puts message
    signature = Base64.encode64 File.read(SIGNATURE)
    pubkey = File.read(PUBLIC_KEY)

    puts  "{ \"message\" : \"#{message}\", \"signature\" : \"#{signature}\", \"pubkey\" : \"#{pubkey}\"}"
  end

  # Validate user input
  def self.validate_input
    if ARGV.length < 1
      return false
    end
    return true
  end

end


