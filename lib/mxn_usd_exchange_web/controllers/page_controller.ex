defmodule MxnUsdExchangeWeb.PageController do
  use MxnUsdExchangeWeb, :controller

  @prefix "exchangesssssxss"
  @day 1000 * 60 * 60 * 24

  def index(conn, _params) do
    {:ok, redis_conn} = Redix.start_link()
    task_1 = Task.async(fn ->
      federation_dairy_info(redis_conn)
    end)
    task_2 = Task.async(fn ->
      fixer_info(redis_conn)
    end)
    task_3 = Task.async(fn ->
      banxico_info(redis_conn)
    end)
    providers = %{
      provider_1: Task.await(task_1),
      provider_2: Task.await(task_2),
      provider_3: Task.await(task_3)
    }
#    providers = %{
#      provider_1: federation_dairy_info(redis_conn),
#      provider_2: fixer_info(redis_conn),
#      provider_3: banxico_info(redis_conn)
#    }
    Redix.stop(redis_conn)
    json conn, providers
  end

  defp cache_check(redis_conn, redis_key, func_data) do
    try do
      provider_data = Redix.command!(redis_conn, ["GET", redis_key])
      data = if is_nil(provider_data) do
        data = func_data.()
#        Task.async(fn ->
#        end)
        Redix.command!(redis_conn, ["SET", redis_key, Poison.encode!(data)])
        Redix.command!(redis_conn, ["PEXPIRE", redis_key, @day])
        data
      else
        data = Poison.decode!(provider_data)
      end
      data
    rescue _e ->
      %{}
    end
  end

  # Banxico

  @banxico_token "d6bc80c4cb78c5057abf22d55ca847adbe8c0c2ed11a530de716e0ce20561c93"
  @banxico_api_url "https://www.banxico.org.mx/SieAPIRest/service/v1/series/SF43718/datos"

  defp banxico_info(redis_conn) do
    cache_key = "#{@prefix}_provider_3"
    cache_check(redis_conn, cache_key, fn ->
      response = HTTPotion.get(
        @banxico_api_url,
        [
          headers: ["Bmx-Token": @banxico_token]
        ]
      )
      response = Poison.decode!(response.body)["bmx"]["series"]
                 |> Enum.at(0)
      response = response["datos"]
      response = Enum.at(response, Enum.count(response) - 1)
      %{
        value: response["dato"],
        last_updated: response["fecha"]
      }
    end)
  end

  # Fixer

  @fixer_api_key "2ed1eab9456263ae00406971dd61ff4d"
  @fixer_api_url "http://data.fixer.io/api/latest?access_key=#{@fixer_api_key}&format=1&symbols=MXN"

  defp fixer_info(redis_conn) do
    cache_key = "#{@prefix}_provider_2"
    cache_check(redis_conn, cache_key, fn ->
      response = HTTPotion.get(@fixer_api_url)
      response = Poison.decode!(response.body)
      %{
        value: response["rates"]["MXN"],
        last_updated: response["date"]
      }
    end)
  end

  # Diario oficial de la federacion

  @federation_dairy_url "http://www.banxico.org.mx/tipcamb/tipCamMIAction.do"

  defp federation_dairy_info(redis_conn) do
    cache_key = "#{@prefix}_provider_1"
    cache_check(redis_conn, cache_key, fn ->
      response = HTTPotion.get(@federation_dairy_url)
      response = Floki.find(response.body, "tr.renglonNon")
                 |> Enum.at(0)
                 |> Floki.raw_html()
                 |> Floki.find("td")

      {_1, _2, date} = Enum.at(response, 0)
      {_1, _2, value} = Enum.at(response, 3)
      response = value ++ date
                 |> Enum.map(fn v ->
        String.trim(v)
      end)
      %{
        value: Enum.at(response, 0),
        last_updated: Enum.at(response, 1)
      }
    end)
  end

end
