# encoding: UTF-8

require 'net/http'
require 'nokogiri'

class BuscaCep::Correios

  BUSCA_CEP_MOBILE_URL = "http://m.correios.com.br/movel/buscaCepConfirma.do"

  def self.buscar(endereco, open_timeout = 5, read_timeout = 5)
    url = URI.parse(BUSCA_CEP_MOBILE_URL)
    req = Net::HTTP::Post.new(url.path)
    req.set_form_data({'cepEntrada' => endereco.encode('ISO-8859-1'), 'metodo' => 'buscarCep'})

    http = Net::HTTP.new(url.host, url.port)
    http.open_timeout = open_timeout
    http.read_timeout = read_timeout

    response = http.request(req)
    raise "A busca mobile de CEP através dos Correios está indisponível." unless response.kind_of?(Net::HTTPSuccess)

    doc = Nokogiri::HTML(response.body)
    raise "Endereço não encontrado para #{endereco}." unless doc.css('div:contains("Dados nao encontrados")')[0].nil?

    result = []
    doc.xpath("//form[@id='frmCep']").xpath("div[@class='caixacampobranco' or @class='caixacampoazul']").each do |item|
      street = item.css('.resposta:contains("Logradouro: ") + .respostadestaque,
        .resposta:contains("Endereço: ") + .respostadestaque')[0].content.strip
      # tratamento de endereço da rua, eliminação de parte desnecessária da string, 
      street = clean_street_name street
      district = item.css('.resposta:contains("Bairro: ") + .respostadestaque')[0]
      district = district.content.strip if !district.nil?
      city_state = item.css('.resposta:contains("Localidade / UF: ") + .respostadestaque, 
        .resposta:contains("Localidade/UF: ") + .respostadestaque')[0].content
      code = item.css('.resposta:contains("CEP: ") + .respostadestaque')[0].content
      city = city_state.partition("/")[0].strip
      state = city_state.partition("/")[2].strip
      result << { :street => street, :district => district, :city => city, :state => state, :code => code}
    end
    
    return result
  end

  private

    def self.clean_street_name street
      street.chomp!(", s/n")
      street.chomp!(" s/n")
      street = street.split(" - ").first
      street = street.split(" (Q ").first
      street = street.split(" (Quadra").first
    end

end
