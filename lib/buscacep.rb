$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

%w(busca_cep version).each {|req| require File.dirname(__FILE__) + "/buscacep/#{req}"}


module BuscaCep
end