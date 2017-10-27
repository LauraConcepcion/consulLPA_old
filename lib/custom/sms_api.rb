require 'net/http'
class SMSApi
  attr_accessor :client
  attr_accessor :uri

  def initialize
    @uri = uri
    return unless @uri
    @client = Net::HTTP.new(@uri.host, @uri.port)
  end

  def uri
    return unless end_point_available?
    URI.parse(Rails.application.secrets.sms_end_point)
  end

  def sms_deliver(phone, code)
    return stubbed_response unless end_point_available?

    request = Net::HTTP::Post.new(@uri.request_uri)
    request.set_form_data(request(phone, code))
    request["Content-Type"] = "application/x-www-form-urlencoded"
    response = @client.request(request)
    success?(response)
  end

  def request(phone, code)
    { user_id: Rails.application.secrets.sms_username,
      departamento_id: Rails.application.secrets.sms_department,
      telefono_individual: phone,
      texto: "Clave para verificarte: #{code}. Participa LPA",
      passwd: Rails.application.secrets.sms_password
    }
  end

  def success?(response)
    xml = Nokogiri::XML(response.body)
    xml.xpath('estado').text == 'ok'
  end

  def end_point_available?
    Rails.env.development? || Rails.env.staging? || Rails.env.preproduction? || Rails.env.production?
  end

  def stubbed_response
    {
      estado: 'ok'
    }
  end

end
