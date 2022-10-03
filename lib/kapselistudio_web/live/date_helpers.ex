defmodule KapselistudioWeb.DateHelpers do
  def format_date(%DateTime{} = date) do
    date_to_str(date)
  end

  def format_date(%NaiveDateTime{} = date) do
    date_to_str(date)
  end

  def format_date(_) do
    "-"
  end

  defp date_to_str(date) do
    Timex.format!(date, "{D}.{M}.{YYYY}")
  end
end
