require "code_challenge"

describe CodeChallenge do

  before do
    @message = "test message"
    @diff_message = "different test message"
  end

  describe ".generate_keys" do
    context "when called" do
      it "creates key files" do
        CodeChallenge.generate_keys(@message)
        expect(File.exist?(PUBLIC_KEY)).to eql(true)
      end
    end
  end

  describe ".verify"  do
    context "when the correct message is provided" do
      it "returns true" do
        key = OpenSSL::PKey::RSA.new File.read PRIVATE_KEY
        digest = OpenSSL::Digest::SHA256.new
        signature = File.read(SIGNATURE)
        expect(CodeChallenge.verify(key.public_key, digest, signature, @message)).to eql(true) 
      end
    end
    context "when the incorrect message is provided" do
      it "returns false" do
        key = OpenSSL::PKey::RSA.new File.read PRIVATE_KEY
        digest = OpenSSL::Digest::SHA256.new
        signature = File.read(SIGNATURE)
        expect(CodeChallenge.verify(key.public_key, digest, signature, @diff_message)).to eql(false) 
      end
    end
  end

end
  
