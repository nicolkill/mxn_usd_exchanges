defmodule MxnUsdExchangeWeb.PageControllerTest do
  use MxnUsdExchangeWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "exchange" do
    test "get exchange of 1 USD to MXN", %{conn: conn} do
      conn = conn
             |> get("/api/v1/mxn_to_usd")

      IO.inspect json_response(conn, 200)

#      assert check_maps(json_response(conn, 200)["data"], %{
#        "id" => id,
#        "email" => user.email,
#        "name" => user.name,
#        "surname" => user.surname,
#        "age" => user.age,
#        "gender" => user.gender
#      })
    end
  end

end