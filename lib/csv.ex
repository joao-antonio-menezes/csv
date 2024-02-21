defmodule Csv do
  @moduledoc """
  A função parse/1 deve receber o nome de um arquivo CSV no disco.

  Um arquivo CSV é formado por:
  - Uma linha de cabeçalho, que contém o nome das colunas
  - Uma ou mais linhas de dados, onde cada linha contém os valores das colunas

  Após a leitura do arquivo, a função deve retornar uma lista de mapas, onde cada mapa representa uma linha de dados.

  Para isso, a função deve detectar a primeira linha, separar em vírgulas, e depois criar um mapa com
  as chaves sendo os nomes das colunas e os valores sendo os valores das colunas.

  Se o arquivo não existir, a função deve retornar {:error, "File not found"}

  Se o arquivo estiver vazio, a função deve retornar {:error, "File is empty"}

  Se o arquivo não estiver no formato correto, ou seja, se alguma das linhas tiver um número diferente de colunas,
  a função deve retornar {:error, "Invalid CSV"}.

  Você pode assumir que o valor das colunas não contém nenhuma vírgula.
  """

  @spec parse(binary()) :: {:ok, [map()]} | {:error, String.t()}
  def parse(file) do
    case File.read(file) do
      {:ok, conteudo} ->
        if byte_size(conteudo) == 0 do
          {:error, "File is empty"}
          else
            analise_conteudo(conteudo)
          end
      {:error, _} -> {:error, "File not found"}
    end
  end

  defp analise_conteudo(conteudo) do
      [linha_cabecalho | linha_dado] = String.split(conteudo, "\n")
      analise_dados(linha_cabecalho, linha_dado)
  end

  defp analise_dados(linha_cabecalho, linha_dado) do
    cabecalho = String.split(linha_cabecalho, ",")
    valores_tabela = Enum.map(linha_dado, fn linha -> dados = String.split(linha, ",")
        if length(dados) != length(cabecalho) do
          {:error, "Invalid CSV"}
        else
          Enum.zip(cabecalho, dados) |> Map.new()
        end
      end)

    {:ok, valores_tabela}
  end
end

