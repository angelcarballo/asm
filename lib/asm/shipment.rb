require 'erb'
require 'savon'

class Asm::Shipment
  WDSL = 'http://www.asmred.com/WebSrvs/b2b.asmx?WSDL'
  TEST_UID = '6BAB7A53-3B6D-4D5A-9450-702D2FAC0B11'

  TEMPLATE = File.expand_path("../../../templates/shipment.xml.erb", __FILE__)

  MANDATORY_KEYS =  %i(client_uid date reference_number origin destination service)
  OPTIONAL_KEYS = %i(packages reimbursement_cents)
  KEYS = MANDATORY_KEYS + OPTIONAL_KEYS

  DEFAULT_KEYS = {packages: 1, date: Date.today}

  SERVICES = {courier: 1, economy: 37, euro_standar: 54}

  attr_reader :response
  attr_accessor *KEYS

  def initialize(options = {})
    options = DEFAULT_KEYS.merge(options)
    KEYS.each do |key|
      instance_variable_set "@#{key}", options[key]
    end
    @origin = Address.new(options[:origin])
    @destination = Address.new(options[:destination])
    validate!
    return self
  end

  def request!
    @raw_response = client.call(:graba_servicios, xml: message)
  end

  def response
    return nil unless @raw_response
    @raw_response.body[:graba_servicios_response][:graba_servicios_result][:servicios][:envio]
  end

  def sucess?
    response[:resultado][:@return].to_i.zero?
  end

  def errors
    response[:errores][:error]
  end

  ## Calculated Fields
  
  def service_code
    SERVICES[service]
  end

  def reimbursement
    reimbursement_cents.to_f / 100.0
  end

  def formatted_date
    if date.respond_to?(:strftime)
      date.strftime("%d/%m/%Y")
    else
      date.to_s
    end
  end

  private

  def validate!
    for key in MANDATORY_KEYS
      raise InvalidConfig, "#{key} must be defined" unless public_send(key)
    end
    raise InvalidConfig, "#{key} is not valid" unless SERVICES.include? service
    origin.validate_for! service
    destination.validate_for! service
  end

  # xml message from template
  # compiled message must be minified to avoid XML errors
  def message
    ERB.new(File.read(TEMPLATE)).result(binding).lines.map(&:strip).join
  end

  def client
    @client ||=  Savon.client(wsdl: WDSL)
  end

end

class Address
  MANDATORY_KEYS = %i(name address city country_code zipcode)
  OPTIONAL_KEYS = %i(state phone observations mobile email)
  KEYS = MANDATORY_KEYS + OPTIONAL_KEYS

  attr_reader *KEYS

  def initialize(options = {})
    KEYS.each do |key|
      instance_variable_set "@#{key}", options[key]
    end
  end

  def validate_for!(service)
    keys_to_valide = MANDATORY_KEYS
    keys_to_valide << :mobile << :email if service == :euro_standar
    for key in keys_to_valide
       raise InvalidConfig, "#{key} must be defined" unless public_send(key)
    end
  end
end
