require 'erb'
require 'savon'

class Asm::Collection
  WDSL = 'http://www.asmred.com/WebSrvs/b2b.asmx?WSDL'
  TEMPLATE = File.expand_path("../../../templates/collection.xml.erb", __FILE__)
  OPTIONS = [
    :client_uid, :date, :time_from, :time_to, :reference_number, :name,
    :address, :city, :state, :country_code, :zipcode, :phone, :mobile, :email
  ]

  attr_reader :response
  attr_accessor *OPTIONS

  def initialize(options = {})
    OPTIONS.each do |op|
      instance_variable_set "@#{op}", options[op]
    end
  end

  def message
    ERB.new(File.read(TEMPLATE)).result(binding)
  end

  def client
    @client ||=  Savon.client(wsdl: WDSL)
  end

  def request!
    @response = client.call(:graba_servicios, xml: message)
  end
end
