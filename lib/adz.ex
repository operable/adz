defmodule Adz do

  defmacro __using__(_) do
    quote do
      require Logger
      import unquote(__MODULE__), only: [ready: 1]
    end
  end

  defmacro ready(value) do
    quote bind_quoted: [value: value] do
      Logger.info("ready.")
      value
    end
  end

  def text(level, msg, {date, time}, metadata) do
    "#{format_date(date)} #{format_time(time)}"
    <> format_metadata(metadata)
    <> "[#{level}] #{format_message(msg)}"
    <> format_extra(Keyword.get(metadata, :extra)) <> "\n"
  end

  def json(level, msg, {date, time}, metadata) do
    entry = add_metadata(%{timestamp: "#{format_date(date)} #{format_time(time)}",
                           level: "#{level}",
                           message: format_message(msg)}, metadata)
    Poison.encode!(entry) <> "\n"
  end

  defp format_extra(nil), do: ""
  defp format_extra(extra), do: "#{inspect extra}"

  defp format_message(msg) when is_binary(msg), do: msg
  defp format_message(msg) when is_list(msg) do
    :erlang.iolist_to_binary(msg)
  end

  defp format_metadata(metadata) do
    module = format_module(Keyword.get(metadata, :module))
    line = Keyword.get(metadata, :line)
    if module != nil and line != nil do
      " (#{module}:#{line}) "
    else
      " () "
    end
  end

  defp add_metadata(entry, metadata) do
    module = format_module(Keyword.get(metadata, :module))
    line = Keyword.get(metadata, :line)
    entry = if module != nil and line != nil do
      entry
      |> Map.put(:source, "#{module}")
      |> Map.put(:line, line)
    else
      entry
      |> Map.put(:source, "n/a")
      |> Map.put(:line, "n/a")
    end
    add_extra(entry, Keyword.get(metadata, :extra))
  end

  defp add_extra(entry, nil) do
    entry
  end
  defp add_extra(entry, extra) do
    cond do
      is_list(extra) ->
        Map.merge(entry, :maps.from_list(extra), &merge_extra_metadata/3)
      is_map(extra) ->
        Map.merge(entry, extra, &merge_extra_metadata/3)
      true ->
        Map.put(entry, :extra, "#{inspect extra}")
    end
  end

  defp merge_extra_metadata(_key, v1, v2) do
    cond do
      is_list(v1) and is_list(v2) ->
        v1 ++ v2
      is_list(v1) ->
        v1 ++ [v2]
      is_list(v2) ->
        [v1|v2]
      true ->
        [v1, v2]
    end
  end



  defp format_module(nil), do: nil
  defp format_module(module) do
    inspect(module)
  end

  defp format_date({year, month, day}) do
    month = format_number(month)
    day = format_number(day)
    "#{month}-#{day}-#{year}"
  end

  defp format_time({hour, min, sec}) do
    hour = format_number(hour)
    min = format_number(min)
    sec = format_number(sec)
    "#{hour}:#{min}:#{sec}"
  end
  defp format_time({hour, min, sec, micro}) do
    hour = format_number(hour)
    min = format_number(min)
    sec = format_number(sec)
    micro = format_number(micro)
    "#{hour}:#{min}:#{sec}:#{micro}"
  end

  defp format_number(n) when n < 10 do
    "0#{n}"
  end
  defp format_number(n), do: "#{n}"

end
