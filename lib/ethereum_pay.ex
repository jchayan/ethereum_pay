defmodule EthereumPay do  
  use Application

  def start(_type, _args) do  
    EthereumPay.Supervisor.start_link nil 
  end  
end 
