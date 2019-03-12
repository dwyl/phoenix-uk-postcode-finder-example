defmodule StoreFinderWeb.PageControllerTest do
  use StoreFinderWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Search"
  end

  describe "testing nearby-stores route" do
    test "postcode with invalid format redirects to /", %{conn: conn} do
      conn = post(conn, "/nearby-stores", postcode: "bad-postcode", within: "1")
      assert redirected_to(conn, 302) == "/"
      assert get_flash(conn, :error) == "invalid postcode"
    end

    test "invalid postcode but with valid format redirects to /", %{conn: conn} do
      conn = post(conn, "/nearby-stores", postcode: "z11zz", within: "1")
      assert redirected_to(conn, 302) == "/"
      assert get_flash(conn, :error) == "invalid postcode"
    end

    test "Valid postcodes takes user to resutls page", %{conn: conn} do
      conn = post(conn, "/nearby-stores", postcode: "n43hf", within: "1")
      assert html_response(conn, 200) =~ "Nearby Stores"
    end
  end
end
