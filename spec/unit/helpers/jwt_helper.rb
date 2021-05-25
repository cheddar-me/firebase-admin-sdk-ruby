require "openssl"

module JWTHelper
  def stub_certificate_request(certificates, uri)
    certificates = JSON.generate(certificates) if certificates.is_a?(Hash)
    stub_request(:get, uri)
      .to_return(
        status: 200,
        body: certificates,
        headers: {
          "cache-control": "public, max-age=600, must-revalidate, no-transform",
          "content-type": "application/json; charset=utf-8"
        }
      )
  end

  def encode_jwt(algorithm, kid = nil, key = nil, payload = {})
    now = Time.now.to_i
    payload = {
      iss: "https://securetoken.google.com/test-adminsdk-project",
      aud: "test-adminsdk-project",
      sub: "12345",
      iat: now,
      exp: now + 15.minutes
    }.merge(payload).compact
    headers = {kid: kid}.compact
    JWT.encode(payload, key, algorithm, headers)
  end

  def create_certificate
    key = OpenSSL::PKey::RSA.new(2048)
    public_key = key.public_key

    subject = "/C=BE/O=Test/OU=Test/CN=Test"

    cert = OpenSSL::X509::Certificate.new
    cert.subject = cert.issuer = OpenSSL::X509::Name.parse(subject)
    cert.not_before = Time.now
    cert.not_after = Time.now + 3600
    cert.public_key = public_key
    cert.serial = 0x0
    cert.version = 2

    ef = OpenSSL::X509::ExtensionFactory.new
    ef.subject_certificate = cert
    ef.issuer_certificate = cert
    cert.extensions = [
      ef.create_extension("basicConstraints", "CA:TRUE", true),
      ef.create_extension("subjectKeyIdentifier", "hash")
    ]
    cert.add_extension ef.create_extension("authorityKeyIdentifier", "keyid:always,issuer:always")

    cert.sign key, OpenSSL::Digest.new("SHA256")
    [key, cert.to_pem]
  end
end
