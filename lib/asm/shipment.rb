require 'erb'
require 'savon'

class Asm::Shipment
  WDSL = 'http://www.asmred.com/WebSrvs/b2b.asmx?WSDL'
  TEST_UID = '6BAB7A53-3B6D-4D5A-9450-702D2FAC0B11'

  TEMPLATE = File.expand_path("../../../templates/shipment.xml.erb", __FILE__)
  OPTIONS = %i(client_uid date packages reference_number reimbursement_cents origin destination)
  DEFAULT_OPTIONS = {packages: 1, date: Date.today}

  attr_reader :response
  attr_accessor *OPTIONS

  def initialize(options = {})
    options = DEFAULT_OPTIONS.merge(options)
    OPTIONS.each do |key|
      instance_variable_set "@#{key}", options[key]
    end
    @origin = Address.new(options[:origin])
    @destination = Address.new(options[:destination])
  end

  # xml message from template
  # compiled message must be minified to avoid XML errors
  def message
    ERB.new(File.read(TEMPLATE)).result(binding).lines.map(&:strip).join
  end

  def client
    @client ||=  Savon.client(wsdl: WDSL)
  end

  def request!
    @response = client.call(:graba_servicios, xml: message)
  end

  def reimbursement
    reimbursement_cents.to_f / 100.0
  end

end

class Address
  OPTIONS = %i(name address city state country_code zipcode phone mobile email observations)
  attr_reader *OPTIONS

  def initialize(options = {})
    OPTIONS.each do |key|
      instance_variable_set "@#{key}", options[key]
    end
  end
end
