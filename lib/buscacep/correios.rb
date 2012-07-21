# encoding: UTF-8

require 'net/http'
require 'nokogiri'

class BuscaCep::Correios

  BUSCA_CEP_MOBILE_URL = "http://m.correios.com.br/movel/buscaCepConfirma.do"

  def self.buscar(endereco)
    url = URI.parse(BUSCA_CEP_MOBILE_URL)
    req = Net::HTTP::Post.new(url.path)
    req.set_form_data({'cepEntrada' => endereco, 'metodo' => 'buscarCep'})

    http = Net::HTTP.new(url.host, url.port)
    http.open_timeout = 5
    http.read_timeout = 5

    response = http.request(req)
    raise "A busca mobile de CEP através dos Correios está indisponível." unless response.kind_of?(Net::HTTPSuccess)

    doc = Nokogiri::HTML(response.body)
    raise "Endereço não encontrado para #{endereco}." unless doc.css('div:contains("Dados nao encontrados")')[0].nil?

    result = []
    doc.css('div.caixacampobranco').each do |item|
      street = item.css('.resposta:contains("Logradouro: ") + .respostadestaque')[0].content.strip
      district = item.css('.resposta:contains("Bairro: ") + .respostadestaque')[0].content.strip
      city_state = item.css('.resposta:contains("Localidade / UF: ") + .respostadestaque')[0].content
      code = item.css('.resposta:contains("CEP: ") + .respostadestaque')[0].content
      city = city_state.partition("/")[0].strip
      state = city_state.partition("/")[2].strip
      result << { :street => street, :district => district, :city => city, :state => state, :code => code}
    end
    
    return result
  end

end
