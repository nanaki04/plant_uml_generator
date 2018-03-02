defmodule PlantUMLGeneratorTest do
  use ExUnit.Case
  doctest PlantUMLGenerator

  test "generates a plant uml file" do
    result = CodeParserState.Example.generate
    |> PlantUMLGenerator.generate
    assert :ok = result
    assert {:ok, _} = File.read "export.uml"
  end
end
